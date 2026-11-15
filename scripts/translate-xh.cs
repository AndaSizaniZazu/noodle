#:package Npgsql@10.0.0
#:property PublishAot=false
// Drafts isiXhosa translations for course text that has none yet, using Claude via OpenRouter.
// Uses the API's saved secrets (ConnectionStrings:Supabase, OpenRouter:ApiKey).
// Usage:  dotnet run scripts/translate-xh.cs            (only missing translations)
//         dotnet run scripts/translate-xh.cs -- --all   (re-translate everything not marked reviewed)
// Output is a DRAFT: a fluent isiXhosa speaker must review it before teachers rely on it.
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using Npgsql;

var all = args.Contains("--all");
const string userSecretsId = "2c20609d-9154-4c61-bf25-7620e690f778";
const string Model = "anthropic/claude-opus-5.5";

var secretsPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
    "Microsoft", "UserSecrets", userSecretsId, "secrets.json");
using var secrets = JsonDocument.Parse(File.ReadAllText(secretsPath));
string Secret(string key) => secrets.RootElement.TryGetProperty(key, out var v) && v.GetString() is { Length: > 0 } s
    ? s : throw new InvalidOperationException($"{key} is not set. Run scripts/set-secrets.ps1 first.");

var http = new HttpClient { BaseAddress = new Uri("https://openrouter.ai/api/v1/"), Timeout = TimeSpan.FromMinutes(5) };
http.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", Secret("OpenRouter:ApiKey"));
http.DefaultRequestHeaders.Add("X-Title", "Noodle translation");

await using var db = NpgsqlDataSource.Create(new NpgsqlConnectionStringBuilder(Secret("ConnectionStrings:Supabase")) { Timeout = 30 }.ConnectionString);

const string System = """
    You translate teacher-training course content from English into isiXhosa for teachers in the
    Eastern Cape, South Africa, whose home language is isiXhosa. The course teaches how to write
    good prompts for AI chat tools.

    Rules:
    - Write natural, clear, everyday isiXhosa that a teacher would speak. Short sentences. Not old-fashioned or overly formal.
    - Keep these terms in English (you may explain them briefly in isiXhosa the first time they appear):
      AI, prompt, prompt engineering, chat, RTCF, Role, Task, Context, Format, Constraints, CAPS, ATP, POPIA,
      memo, rubric, few-shot prompting, hallucination, template, toolkit, Playground, WhatsApp, Grade R, LoLT, FAL,
      SIAS, SBST, PLC, NSC, SBA, PAT, FET, Senior Phase, Mathematical Literacy, Bloom's, Barrett's, exit ticket,
      think–pair–share, CHECK (the checklist letters C, H, E, C, K), and app names
      (ChatGPT, Gemini, Claude, Meta AI, Copilot, Word, Google Docs).
    - Keep Markdown exactly: the same headings, bold, lists and tables, in the same order.
    - Lines starting with ">" are example prompts that teachers will copy into an AI tool.
      Copy every ">" line EXACTLY as it is, in English. Do not translate them.
    - In "Key words" tables, keep the first column (the English word) in English and translate the other
      columns. Translate the table header row.
    - Text in quotation marks that a teacher would type to the AI (for example "Make it shorter.") stays in English;
      you may add the isiXhosa meaning in brackets after it.
    - Keep names, numbers, money amounts (R50), grades and dates unchanged.
    - Do not add or remove content. Do not add notes about the translation.
    Reply with only the JSON object described by the schema.
    """;

int done = 0, failed = 0;

// ---- Course and modules (one call) -------------------------------------------------------
{
    var items = new JsonArray();
    await using (var cmd = db.CreateCommand(
        "select 'course' as kind, id, title, summary from courses where @all or title_xh is null " +
        "union all select 'module', id, title, summary from modules where @all or title_xh is null"))
    {
        cmd.Parameters.AddWithValue("all", all);
        await using var r = await cmd.ExecuteReaderAsync();
        while (await r.ReadAsync())
            items.Add(new JsonObject { ["kind"] = r.GetString(0), ["id"] = r.GetGuid(1).ToString(), ["title"] = r.GetString(2), ["summary"] = r.GetString(3) });
    }
    if (items.Count > 0)
    {
        Console.WriteLine($"Translating {items.Count} course/module titlesâ€¦");
        var schema = Obj(("items", Arr(Obj(("id", Str()), ("title", Str()), ("summary", Str())))));
        var result = await Translate($"Translate the title and summary of each item.\n{items.ToJsonString()}", schema);
        foreach (var it in result!["items"]!.AsArray())
        {
            var id = Guid.Parse(it!["id"]!.GetValue<string>());
            var kind = items.First(x => x!["id"]!.GetValue<string>() == id.ToString())!["kind"]!.GetValue<string>();
            await Exec($"update {(kind == "course" ? "courses" : "modules")} set title_xh=@t, summary_xh=@s where id=@id",
                ("t", it["title"]!.GetValue<string>()), ("s", it["summary"]!.GetValue<string>()), ("id", id));
            done++;
        }
    }
}

// ---- Lessons (one call each, 4 at a time) ---------------------------------------------------
var lessons = new List<(Guid Id, string Title, string Content, string? Task)>();
await using (var cmd = db.CreateCommand(
    "select id, title, content_md, practice_task from lessons where (@all and not xh_reviewed) or content_md_xh is null order by module_id, position"))
{
    cmd.Parameters.AddWithValue("all", all);
    await using var r = await cmd.ExecuteReaderAsync();
    while (await r.ReadAsync())
        lessons.Add((r.GetGuid(0), r.GetString(1), r.GetString(2), r.IsDBNull(3) ? null : r.GetString(3)));
}
Console.WriteLine($"Translating {lessons.Count} lessonsâ€¦");
await Parallel.ForEachAsync(lessons, new ParallelOptions { MaxDegreeOfParallelism = 1 }, async (l, _) =>
{
    try
    {
        var input = new JsonObject { ["title"] = l.Title, ["content_md"] = l.Content, ["practice_task"] = l.Task ?? "" };
        var schema = Obj(("title", Str()), ("content_md", Str()), ("practice_task", Str()));
        var t = await Translate($"Translate this lesson.\n{input.ToJsonString()}", schema);
        var md = t!["content_md"]!.GetValue<string>();

        // Safety check: every example prompt (">" line) must survive unchanged.
        var before = Quotes(l.Content);
        var after = Quotes(md);
        if (!before.SequenceEqual(after))
            Console.WriteLine($"  ! {l.Title}: example prompts changed â€” please review this lesson carefully.");

        await Exec("update lessons set title_xh=@t, content_md_xh=@c, practice_task_xh=@p, xh_reviewed=false where id=@id",
            ("t", t["title"]!.GetValue<string>()), ("c", md),
            ("p", l.Task is null ? DBNull.Value : t["practice_task"]!.GetValue<string>()), ("id", l.Id));
        Interlocked.Increment(ref done);
        Console.WriteLine($"  âœ“ {l.Title}");
    }
    catch (Exception ex)
    {
        Interlocked.Increment(ref failed);
        Console.WriteLine($"  âœ— {l.Title}: {ex.Message}");
    }
});

// ---- Quiz questions (one call per module) ---------------------------------------------------
var questions = new List<(Guid ModuleId, Guid Id, string Q, string Options, string Expl)>();
await using (var cmd = db.CreateCommand(
    "select module_id, id, question, options::text, explanation from quiz_questions where @all or question_xh is null order by module_id, position"))
{
    cmd.Parameters.AddWithValue("all", all);
    await using var r = await cmd.ExecuteReaderAsync();
    while (await r.ReadAsync())
        questions.Add((r.GetGuid(0), r.GetGuid(1), r.GetString(2), r.GetString(3), r.GetString(4)));
}
Console.WriteLine($"Translating {questions.Count} quiz questionsâ€¦");
await Parallel.ForEachAsync(questions.GroupBy(q => q.ModuleId), new ParallelOptions { MaxDegreeOfParallelism = 1 }, async (group, _) =>
{
    try
    {
        var input = new JsonArray(group.Select(q => (JsonNode)new JsonObject
        {
            ["id"] = q.Id.ToString(), ["question"] = q.Q,
            ["options"] = JsonNode.Parse(q.Options), ["explanation"] = q.Expl,
        }).ToArray());
        var schema = Obj(("items", Arr(Obj(("id", Str()), ("question", Str()), ("options", Arr(Str())), ("explanation", Str())))));
        var t = await Translate($"Translate each quiz question, every option (same order and number), and the explanation.\n{input.ToJsonString()}", schema);
        foreach (var it in t!["items"]!.AsArray())
        {
            var id = Guid.Parse(it!["id"]!.GetValue<string>());
            var original = group.First(q => q.Id == id);
            var opts = it["options"]!.AsArray();
            if (opts.Count != JsonNode.Parse(original.Options)!.AsArray().Count)
                throw new InvalidOperationException($"option count changed for question {id}");
            await Exec("update quiz_questions set question_xh=@q, options_xh=@o::jsonb, explanation_xh=@e where id=@id",
                ("q", it["question"]!.GetValue<string>()), ("o", opts.ToJsonString()),
                ("e", it["explanation"]!.GetValue<string>()), ("id", id));
            Interlocked.Increment(ref done);
        }
        Console.WriteLine($"  âœ“ {group.Count()} questions");
    }
    catch (Exception ex)
    {
        Interlocked.Increment(ref failed);
        Console.WriteLine($"  âœ— quiz group: {ex.Message}");
    }
});

Console.WriteLine($"Done. Translated {done} items, {failed} failed. Remember: these are drafts for a fluent speaker to review.");
return failed == 0 ? 0 : 1;

// ---- helpers ---------------------------------------------------------------------------------
async Task<JsonNode?> Translate(string user, JsonObject schema)
{
    var body = new JsonObject
    {
        ["model"] = Model,
        // Kept modest: OpenRouter reserves credit for max_tokens on every in-flight request.
        ["max_tokens"] = 8000,
        ["reasoning"] = new JsonObject { ["effort"] = "medium" },
        ["messages"] = new JsonArray
        {
            new JsonObject { ["role"] = "system", ["content"] = System },
            new JsonObject { ["role"] = "user", ["content"] = user },
        },
        ["response_format"] = new JsonObject
        {
            ["type"] = "json_schema",
            ["json_schema"] = new JsonObject { ["name"] = "translation", ["strict"] = true, ["schema"] = schema },
        },
        ["provider"] = new JsonObject { ["require_parameters"] = true },
    };
    for (var attempt = 1; ; attempt++)
    {
        using var res = await http.PostAsync("chat/completions", new StringContent(body.ToJsonString(), Encoding.UTF8, "application/json"));
        var text = await res.Content.ReadAsStringAsync();
        if (res.IsSuccessStatusCode)
        {
            var content = JsonNode.Parse(text)!["choices"]![0]!["message"]!["content"]!.GetValue<string>();
            var s = content.IndexOf('{'); var e = content.LastIndexOf('}');
            return JsonNode.Parse(content[s..(e + 1)]);
        }
        // 402 "in_flight_budget_exhausted" just means too much credit is reserved right now: wait and retry.
        var retryable402 = (int)res.StatusCode == 402 && text.Contains("in_flight");
        if (attempt >= 4 || ((int)res.StatusCode is 400 or 401 or 402 && !retryable402))
            throw new InvalidOperationException($"OpenRouter {(int)res.StatusCode}: {text[..Math.Min(300, text.Length)]}");
        await Task.Delay(TimeSpan.FromSeconds(5 * attempt));
    }
}

async Task Exec(string sql, params (string Name, object Value)[] ps)
{
    await using var cmd = db.CreateCommand(sql);
    foreach (var (n, v) in ps) cmd.Parameters.AddWithValue(n, v);
    await cmd.ExecuteNonQueryAsync();
}

static List<string> Quotes(string md) =>
    md.Split('\n').Select(x => x.TrimEnd()).Where(x => x.StartsWith('>')).ToList();

static JsonObject Str() => new() { ["type"] = "string" };
static JsonObject Arr(JsonObject items) => new() { ["type"] = "array", ["items"] = items };
static JsonObject Obj(params (string Name, JsonObject Schema)[] props)
{
    var p = new JsonObject();
    foreach (var (n, s) in props) p[n] = s;
    return new JsonObject
    {
        ["type"] = "object",
        ["properties"] = p,
        ["required"] = new JsonArray(props.Select(x => (JsonNode)JsonValue.Create(x.Name)).ToArray()),
        ["additionalProperties"] = false,
    };
}
