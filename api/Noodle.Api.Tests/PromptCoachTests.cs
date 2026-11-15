using System.Text.Json;
using Noodle.Api.Services;

namespace Noodle.Api.Tests;

public class PromptCoachTests
{
    /// <summary>Fake model: records calls and returns canned replies, so tests never hit the network.</summary>
    private sealed class FakeModel(params string[] replies) : IChatModel
    {
        private int _i;
        public int Calls => _i;
        public Task<string> AskAsync(string system, string user, bool lowEffort, IReadOnlyDictionary<string, JsonElement>? jsonSchema, CancellationToken ct)
            => Task.FromResult(replies[_i++]);
    }

    private const string GoodJson = """
        {"role":2,"task":2,"context":1,"format":0,"constraints":1,"privacy_concern":false,
         "summary":"Nice start.","strengths":["Clear role"],"improvements":["Add a format"],"improved_prompt":"You are..."}
        """;

    [Theory]
    [InlineData("Write feedback for learner 0801015009087 on her essay")]
    [InlineData("ID: 9912315800084, Grade 7 marks")]
    public async Task Prompt_with_SA_id_number_is_blocked_before_calling_ai(string prompt)
    {
        var model = new FakeModel();
        var ex = await Assert.ThrowsAsync<PromptBlockedException>(() => new PromptCoach(model).RunAsync(prompt, null, CancellationToken.None));
        Assert.Contains("POPIA", ex.Message);
        Assert.Equal(0, model.Calls);
    }

    [Fact]
    public async Task Runs_answer_then_coach_and_scores_out_of_10()
    {
        var model = new FakeModel("Here is a lesson plan...", GoodJson);
        var result = await new PromptCoach(model).RunAsync("You are a Grade 4 teacher. Write a plan.", null, CancellationToken.None);
        Assert.Equal("Here is a lesson plan...", result.AiResponse);
        Assert.Equal(6, result.Feedback.Total);
        Assert.Equal(2, model.Calls);
    }

    [Fact]
    public void Parses_feedback_wrapped_in_code_fence_and_clamps_scores()
    {
        var raw = "```json\n" + GoodJson.Replace("\"role\":2", "\"role\":5") + "\n```";
        var f = PromptCoach.ParseFeedback(raw);
        Assert.Equal(2, f.Role);
        Assert.Equal("Clear role", f.Strengths[0]);
    }

    [Fact]
    public void Unparseable_feedback_gives_friendly_error()
    {
        Assert.Throws<CoachUnavailableException>(() => PromptCoach.ParseFeedback("Sorry, I can't."));
    }
}
