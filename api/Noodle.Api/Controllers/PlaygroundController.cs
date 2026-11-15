using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Noodle.Api.Auth;
using Noodle.Api.Data;
using Noodle.Api.Services;

namespace Noodle.Api.Controllers;

public record PlaygroundRequest(string Prompt, Guid? LessonId);

[ApiController]
[Authorize]
[Route("api/playground")]
public class PlaygroundController(NoodleDb db, PromptCoach coach, IConfiguration config) : ControllerBase
{
    private const int MaxPromptLength = 4000;
    private int DailyLimit => config.GetValue("Playground:DailyLimit", 20);

    [HttpGet("usage")]
    public async Task<IActionResult> Usage(CancellationToken ct)
    {
        var used = await UsedToday(User.UserId(), ct);
        return Ok(new { used, limit = DailyLimit, remaining = Math.Max(0, DailyLimit - used) });
    }

    [HttpPost]
    public async Task<IActionResult> Run(PlaygroundRequest body, CancellationToken ct)
    {
        var userId = User.UserId();
        var prompt = body.Prompt?.Trim() ?? "";
        if (prompt.Length < 10) return BadRequest(new { error = "Please write a longer prompt (at least 10 characters)." });
        if (prompt.Length > MaxPromptLength) return BadRequest(new { error = $"Please keep prompts under {MaxPromptLength} characters." });

        if (await UsedToday(userId, ct) >= DailyLimit)
            return StatusCode(429, new { error = $"You have used all {DailyLimit} practice tries for today. Come back tomorrow!" });

        // The practice task is always given to the coach in English (the source text); the feedback language follows X-Lang.
        string? practiceTask = null;
        if (body.LessonId is { } lessonId)
        {
            practiceTask = await db.Lessons.Where(l => l.Id == lessonId).Select(l => l.PracticeTask).FirstOrDefaultAsync(ct);
        }

        CoachResult result;
        try
        {
            result = await coach.RunAsync(prompt, practiceTask, ct, feedbackInIsiXhosa: Request.IsXh());
        }
        catch (PromptBlockedException ex)
        {
            return UnprocessableEntity(new { error = ex.Message });
        }
        catch (CoachUnavailableException ex)
        {
            return StatusCode(503, new { error = ex.Message });
        }

        var attempt = new PlaygroundAttempt
        {
            UserId = userId,
            LessonId = body.LessonId,
            Prompt = prompt,
            AiResponse = result.AiResponse,
            Feedback = JsonSerializer.SerializeToDocument(result.Feedback),
            TotalScore = result.Feedback.Total,
        };
        db.PlaygroundAttempts.Add(attempt);
        await db.SaveChangesAsync(ct);

        return Ok(new { attempt.Id, aiResponse = result.AiResponse, feedback = result.Feedback, total = result.Feedback.Total, outOf = 10 });
    }

    [HttpGet("history")]
    public async Task<IActionResult> History(CancellationToken ct)
    {
        var userId = User.UserId();
        var items = await db.PlaygroundAttempts.AsNoTracking()
            .Where(a => a.UserId == userId)
            .OrderByDescending(a => a.CreatedAt)
            .Take(20)
            .Select(a => new { a.Id, a.Prompt, a.AiResponse, a.Feedback, a.TotalScore, a.CreatedAt, a.LessonId })
            .ToListAsync(ct);
        return Ok(items);
    }

    private Task<int> UsedToday(Guid userId, CancellationToken ct)
    {
        // "Today" in South African time (UTC+2, no daylight saving).
        var sastMidnight = new DateTimeOffset(DateTime.UtcNow.AddHours(2).Date, TimeSpan.FromHours(2));
        return db.PlaygroundAttempts.CountAsync(a => a.UserId == userId && a.CreatedAt >= sastMidnight, ct);
    }
}
