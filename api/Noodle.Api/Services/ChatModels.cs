using System.Net;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using Anthropic;
using Anthropic.Exceptions;
using Anthropic.Models.Beta.Messages;

namespace Noodle.Api.Services;

/// <summary>One system + user turn in, text out. Low effort = quick chat answers; otherwise a bit more thinking.</summary>
public interface IChatModel
{
    Task<string> AskAsync(string system, string user, bool lowEffort, IReadOnlyDictionary<string, JsonElement>? jsonSchema, CancellationToken ct);
}

/// <summary>Direct Claude API via the official Anthropic SDK.</summary>
public class AnthropicChatModel(AnthropicClient client, ILogger<AnthropicChatModel> log) : IChatModel
{
    private const string Model = "claude-opus-5-5";
    // Refused requests are re-served by the API's default fallback model.
    private const string FallbackBeta = "server-side-fallback-2026-07-01";

    public async Task<string> AskAsync(string system, string user, bool lowEffort, IReadOnlyDictionary<string, JsonElement>? jsonSchema, CancellationToken ct)
    {
        BetaMessage response;
        try
        {
            response = await client.Beta.Messages.Create(new MessageCreateParams
            {
                Model = Model,
                MaxTokens = 8000,
                Betas = [FallbackBeta],
                Fallbacks = new Default(),
                System = system,
                OutputConfig = new BetaOutputConfig
                {
                    Effort = lowEffort ? Effort.Low : Effort.Medium,
                    Format = jsonSchema is null ? null : new BetaJsonOutputFormat { Schema = jsonSchema },
                },
                Messages = [new BetaUserMessageParam { Content = user }],
            }, cancellationToken: ct);
        }
        catch (AnthropicRateLimitException ex)
        {
            log.LogWarning(ex, "Claude rate limit");
            throw new CoachUnavailableException("The AI is busy right now. Please try again in a minute.", ex);
        }
        catch (AnthropicApiException ex)
        {
            log.LogError(ex, "Claude API error");
            throw new CoachUnavailableException("The AI service had a problem. Please try again shortly.", ex);
        }

        if (response.StopReason == "refusal")
            throw new PromptBlockedException("The AI declined this request. Try rephrasing it as a classroom or school task.");

        return string.Concat(response.Content.Select(b => b.TryPickText(out var t) ? t.Text : "")).Trim();
    }
}

/// <summary>Claude through OpenRouter's OpenAI-compatible chat completions endpoint.</summary>
public class OpenRouterChatModel(HttpClient http, IConfiguration config, ILogger<OpenRouterChatModel> log) : IChatModel
{
    private string Model => config["OpenRouter:Model"] is { Length: > 0 } m ? m : "anthropic/claude-opus-5.5";

    public async Task<string> AskAsync(string system, string user, bool lowEffort, IReadOnlyDictionary<string, JsonElement>? jsonSchema, CancellationToken ct)
    {
        var body = new JsonObject
        {
            ["model"] = Model,
            ["max_tokens"] = 8000,
            ["reasoning"] = new JsonObject { ["effort"] = lowEffort ? "low" : "medium" },
            ["messages"] = new JsonArray
            {
                new JsonObject { ["role"] = "system", ["content"] = system },
                new JsonObject { ["role"] = "user", ["content"] = user },
            },
        };
        if (jsonSchema is not null)
        {
            body["response_format"] = new JsonObject
            {
                ["type"] = "json_schema",
                ["json_schema"] = new JsonObject
                {
                    ["name"] = "coach_feedback",
                    ["strict"] = true,
                    ["schema"] = JsonSerializer.SerializeToNode(jsonSchema),
                },
            };
            // Only route to providers that honour the schema.
            body["provider"] = new JsonObject { ["require_parameters"] = true };
        }

        using var req = new HttpRequestMessage(HttpMethod.Post, "chat/completions")
        {
            Content = new StringContent(body.ToJsonString(), Encoding.UTF8, "application/json"),
        };

        HttpResponseMessage res;
        try
        {
            res = await http.SendAsync(req, ct);
        }
        catch (HttpRequestException ex)
        {
            log.LogError(ex, "OpenRouter unreachable");
            throw new CoachUnavailableException("The AI service could not be reached. Please try again shortly.", ex);
        }

        var text = await res.Content.ReadAsStringAsync(ct);
        if (!res.IsSuccessStatusCode)
        {
            log.LogError("OpenRouter error {Status}: {Body}", (int)res.StatusCode, text);
            throw res.StatusCode switch
            {
                HttpStatusCode.TooManyRequests => new CoachUnavailableException("The AI is busy right now. Please try again in a minute."),
                HttpStatusCode.PaymentRequired => new CoachUnavailableException("The AI account has run out of credit. Please tell your facilitator."),
                HttpStatusCode.Unauthorized => new CoachUnavailableException("The AI service is not set up correctly. Please tell your facilitator."),
                _ => new CoachUnavailableException("The AI service had a problem. Please try again shortly."),
            };
        }

        using var doc = JsonDocument.Parse(text);
        var choice = doc.RootElement.GetProperty("choices")[0];
        var finish = choice.TryGetProperty("finish_reason", out var f) ? f.GetString() : null;
        if (finish is "content_filter" or "refusal")
            throw new PromptBlockedException("The AI declined this request. Try rephrasing it as a classroom or school task.");

        var content = choice.GetProperty("message").TryGetProperty("content", out var c) && c.ValueKind == JsonValueKind.String
            ? c.GetString()!
            : "";
        return content.Trim();
    }

    public static void Configure(HttpClient http, IConfiguration config)
    {
        http.BaseAddress = new Uri("https://openrouter.ai/api/v1/");
        http.Timeout = TimeSpan.FromMinutes(3);
        http.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", config["OpenRouter:ApiKey"]);
        // Optional attribution headers OpenRouter shows on its dashboard.
        http.DefaultRequestHeaders.Add("X-Title", "Noodle");
    }
}
