using System.Text.Json;
using System.Text.Json.Serialization;
using System.Text.RegularExpressions;

namespace Noodle.Api.Services;

public record CoachFeedback(
    [property: JsonPropertyName("role")] int Role,
    [property: JsonPropertyName("task")] int Task,
    [property: JsonPropertyName("context")] int Context,
    [property: JsonPropertyName("format")] int Format,
    [property: JsonPropertyName("constraints")] int Constraints,
    [property: JsonPropertyName("privacy_concern")] bool PrivacyConcern,
    [property: JsonPropertyName("summary")] string Summary,
    [property: JsonPropertyName("strengths")] List<string> Strengths,
    [property: JsonPropertyName("improvements")] List<string> Improvements,
    [property: JsonPropertyName("improved_prompt")] string ImprovedPrompt)
{
    /// <summary>Each of the five criteria is scored 0-2, so the total is out of 10.</summary>
    public int Total => Role + Task + Context + Format + Constraints;
}

public record CoachResult(string AiResponse, CoachFeedback Feedback);

public class PromptBlockedException(string message) : Exception(message);
public class CoachUnavailableException(string message, Exception? inner = null) : Exception(message, inner);

/// <summary>
/// Runs a teacher's practice prompt through the AI, then asks the AI to coach the
/// teacher on how well the prompt was written (RTCF + constraints rubric).
/// </summary>
public partial class PromptCoach(IChatModel model)
{
    private const string AssistantSystem =
        "You are a helpful AI assistant. Answer the user's request as well as you can. " +
        "Keep the answer under about 600 words and use simple Markdown formatting.";

    private const string CoachSystem = """
        You coach South African teachers (Eastern Cape Department of Education) who are learning
        prompt engineering. You will see a teacher's prompt, the AI's answer, and optionally the
        practice task they were given. Judge the PROMPT, not the answer.

        Score each criterion 0, 1 or 2:
        - role: does it tell the AI who to act as? (0 none, 1 vague, 2 clear and relevant)
        - task: is the action specific? (0 vague, 1 partly, 2 specific and complete)
        - context: grade, subject, CAPS term/topic, class size, language, resources (0 none, 1 some, 2 rich)
        - format: how the output should look - length, headings, table, memo (0 none, 1 some, 2 clear)
        - constraints: useful limits - time, no printing, reading level, number of items (0 none, 1 one, 2 several)

        privacy_concern is true if the prompt contains learner names, ID numbers, marks tied to a person,
        health, family or other personal information about a real person.

        Write in warm, plain English a busy teacher can read in 30 seconds. Give at most 3 strengths and
        3 improvements, each one short sentence. improved_prompt is a rewritten version of THEIR prompt
        that would score 10/10, keeping their goal and any local details, with no real personal data.

        Reply with only the JSON object described by the schema.
        """;

    private static readonly IReadOnlyDictionary<string, JsonElement> FeedbackSchema =
        JsonSerializer.Deserialize<Dictionary<string, JsonElement>>("""
        {
          "type": "object",
          "properties": {
            "role":            { "type": "integer", "enum": [0, 1, 2] },
            "task":            { "type": "integer", "enum": [0, 1, 2] },
            "context":         { "type": "integer", "enum": [0, 1, 2] },
            "format":          { "type": "integer", "enum": [0, 1, 2] },
            "constraints":     { "type": "integer", "enum": [0, 1, 2] },
            "privacy_concern": { "type": "boolean" },
            "summary":         { "type": "string" },
            "strengths":       { "type": "array", "items": { "type": "string" } },
            "improvements":    { "type": "array", "items": { "type": "string" } },
            "improved_prompt": { "type": "string" }
          },
          "required": ["role","task","context","format","constraints","privacy_concern","summary","strengths","improvements","improved_prompt"],
          "additionalProperties": false
        }
        """)!;

    // South African ID numbers: 13 digits starting with a valid YYMMDD.
    [GeneratedRegex(@"\b\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{7}\b")]
    private static partial Regex SaIdNumber();

    public async Task<CoachResult> RunAsync(string prompt, string? practiceTask, CancellationToken ct, bool feedbackInIsiXhosa = false)
    {
        if (SaIdNumber().IsMatch(prompt))
            throw new PromptBlockedException(
                "Your prompt looks like it contains a South African ID number. Please remove personal information before sending (POPIA).");

        var answer = await model.AskAsync(AssistantSystem, prompt, lowEffort: true, jsonSchema: null, ct);
        if (answer.Length == 0)
            throw new CoachUnavailableException("The AI returned an empty answer. Please try again.");

        var coachInput = $"""
            <practice_task>{practiceTask ?? "(free practice - no set task)"}</practice_task>
            <teacher_prompt>{prompt}</teacher_prompt>
            <ai_answer>{answer}</ai_answer>
            """;
        if (feedbackInIsiXhosa)
            coachInput += "\n<language>The teacher is learning in isiXhosa. Write summary, strengths and improvements in clear, " +
                          "everyday isiXhosa (keep words like prompt, AI, Role, Task, Context, Format, CAPS in English). " +
                          "Write improved_prompt in the same language the teacher used for their prompt.</language>";
        var json = await model.AskAsync(CoachSystem, coachInput, lowEffort: false, FeedbackSchema, ct);
        return new CoachResult(answer, ParseFeedback(json));
    }

    /// <summary>Parses the coach JSON, tolerating a stray code fence or text around the object.</summary>
    public static CoachFeedback ParseFeedback(string raw)
    {
        var start = raw.IndexOf('{');
        var end = raw.LastIndexOf('}');
        if (start < 0 || end <= start)
            throw new CoachUnavailableException("The coach could not give feedback this time. Please try again.");
        try
        {
            var f = JsonSerializer.Deserialize<CoachFeedback>(raw[start..(end + 1)])
                ?? throw new CoachUnavailableException("The coach returned an empty result.");
            static int Clamp(int v) => Math.Clamp(v, 0, 2);
            return f with
            {
                Role = Clamp(f.Role), Task = Clamp(f.Task), Context = Clamp(f.Context),
                Format = Clamp(f.Format), Constraints = Clamp(f.Constraints),
                Strengths = f.Strengths ?? [], Improvements = f.Improvements ?? [],
            };
        }
        catch (JsonException ex)
        {
            throw new CoachUnavailableException("The coach could not give feedback this time. Please try again.", ex);
        }
    }
}
