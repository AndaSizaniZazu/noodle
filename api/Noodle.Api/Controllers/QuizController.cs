using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Noodle.Api.Auth;
using Noodle.Api.Data;

namespace Noodle.Api.Controllers;

public record QuizSubmission(List<int> Answers);

[ApiController]
[Authorize]
[Route("api/modules/{moduleId:guid}/quiz")]
public class QuizController(NoodleDb db) : ControllerBase
{
    /// <summary>Questions without the correct answers.</summary>
    [HttpGet]
    public async Task<IActionResult> Get(Guid moduleId, CancellationToken ct)
    {
        var module = await db.Modules.AsNoTracking()
            .Include(m => m.QuizQuestions)
            .Include(m => m.Course)
            .FirstOrDefaultAsync(m => m.Id == moduleId, ct);
        if (module is null) return NotFound();

        var xh = Request.IsXh();
        return Ok(new
        {
            module.Id, module.Position,
            title = Lang.Pick(xh, module.Title, module.TitleXh),
            courseSlug = module.Course?.Slug,
            questions = module.QuizQuestions.OrderBy(q => q.Position).Select(q => new
            {
                q.Id,
                question = Lang.Pick(xh, q.Question, q.QuestionXh),
                options = xh && q.OptionsXh is { } o && o.Count == q.Options.Count ? o : q.Options,
            }),
        });
    }

    /// <summary>Marks the quiz, stores the attempt and returns per-question explanations.</summary>
    [HttpPost]
    public async Task<IActionResult> Submit(Guid moduleId, QuizSubmission body, CancellationToken ct)
    {
        var questions = await db.QuizQuestions.AsNoTracking()
            .Where(q => q.ModuleId == moduleId)
            .OrderBy(q => q.Position)
            .ToListAsync(ct);
        if (questions.Count == 0) return NotFound();
        if (body.Answers.Count != questions.Count)
            return BadRequest(new { error = $"Please answer all {questions.Count} questions." });

        var xh = Request.IsXh();
        var results = questions.Select((q, i) => new
        {
            questionId = q.Id,
            chosen = body.Answers[i],
            correctIndex = q.CorrectIndex,
            correct = body.Answers[i] == q.CorrectIndex,
            explanation = Lang.Pick(xh, q.Explanation, q.ExplanationXh),
        }).ToList();
        var score = results.Count(r => r.correct);

        db.QuizAttempts.Add(new QuizAttempt
        {
            UserId = User.UserId(),
            ModuleId = moduleId,
            Score = score,
            Total = questions.Count,
            Answers = JsonSerializer.SerializeToDocument(body.Answers),
        });
        await db.SaveChangesAsync(ct);

        return Ok(new { score, total = questions.Count, passed = score * 100 >= questions.Count * 70, results });
    }
}
