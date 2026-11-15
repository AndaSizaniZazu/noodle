using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Noodle.Api.Auth;
using Noodle.Api.Data;

namespace Noodle.Api.Controllers;

public record ProfileUpdate(string FullName, string School, string District);
public record LanguageUpdate(string Language);

[ApiController]
[Authorize]
[Route("api/me")]
public class MeController(NoodleDb db) : ControllerBase
{
    public static readonly string[] Districts =
    [
        "Alfred Nzo East", "Alfred Nzo West", "Amathole East", "Amathole West", "Buffalo City Metro",
        "Chris Hani East", "Chris Hani West", "Joe Gqabi", "Nelson Mandela Bay", "OR Tambo Coastal",
        "OR Tambo Inland", "Sarah Baartman",
    ];

    [AllowAnonymous]
    [HttpGet("/api/districts")]
    public IActionResult GetDistricts() => Ok(Districts);

    [HttpGet]
    public async Task<IActionResult> Get(CancellationToken ct)
    {
        var profile = await EnsureProfile(ct);
        return Ok(new { profile.Id, email = User.Email(), profile.FullName, profile.School, profile.District, profile.Role, profile.Language });
    }

    /// <summary>Saves the teacher's preferred language ("en" or "xh") so it follows them to other devices.</summary>
    [HttpPut("language")]
    public async Task<IActionResult> SetLanguage(LanguageUpdate body, CancellationToken ct)
    {
        if (body.Language is not ("en" or "xh")) return BadRequest(new { error = "Language must be en or xh." });
        var profile = await EnsureProfile(ct);
        profile.Language = body.Language;
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    [HttpPut]
    public async Task<IActionResult> Update(ProfileUpdate body, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(body.FullName)) return BadRequest(new { error = "Please enter your name." });
        if (!string.IsNullOrEmpty(body.District) && !Districts.Contains(body.District))
            return BadRequest(new { error = "Please choose a district from the list." });

        var profile = await EnsureProfile(ct);
        profile.FullName = body.FullName.Trim();
        profile.School = body.School?.Trim() ?? "";
        profile.District = body.District ?? "";
        await db.SaveChangesAsync(ct);
        return NoContent();
    }

    /// <summary>Dashboard numbers for the signed-in teacher.</summary>
    [HttpGet("summary")]
    public async Task<IActionResult> Summary(CancellationToken ct)
    {
        var userId = User.UserId();
        var totalLessons = await db.Lessons.CountAsync(ct);
        var completed = await db.LessonProgress.CountAsync(p => p.UserId == userId, ct);
        var quizzesPassed = await db.QuizAttempts
            .Where(a => a.UserId == userId && a.Score * 100 >= a.Total * 70)
            .Select(a => a.ModuleId).Distinct().CountAsync(ct);
        var practice = await db.PlaygroundAttempts.Where(a => a.UserId == userId)
            .GroupBy(_ => 1)
            .Select(g => new { count = g.Count(), best = g.Max(a => a.TotalScore), avg = g.Average(a => a.TotalScore) })
            .FirstOrDefaultAsync(ct);
        // Next lesson: stay in the course the teacher worked in most recently, then the other courses in order.
        var activeCourseId = await (
                from p in db.LessonProgress
                join l in db.Lessons on p.LessonId equals l.Id
                where p.UserId == userId
                orderby p.CompletedAt descending
                select (Guid?)l.Module!.CourseId)
            .FirstOrDefaultAsync(ct);
        var nextLesson = await db.Lessons.AsNoTracking()
            .Where(l => l.Module!.Course!.IsPublished)
            .Where(l => !db.LessonProgress.Any(p => p.UserId == userId && p.LessonId == l.Id))
            .OrderBy(l => l.Module!.CourseId == activeCourseId ? 0 : 1)
            .ThenBy(l => l.Module!.Course!.CreatedAt)
            .ThenBy(l => l.Module!.Position).ThenBy(l => l.Position)
            .Select(l => new
            {
                l.Id, l.Title, l.TitleXh,
                ModuleTitle = l.Module!.Title, ModuleTitleXh = l.Module!.TitleXh,
                CourseTitle = l.Module!.Course!.Title, CourseTitleXh = l.Module!.Course!.TitleXh,
            })
            .FirstOrDefaultAsync(ct);
        var xh = Request.IsXh();

        return Ok(new
        {
            totalLessons, completedLessons = completed, quizzesPassed,
            totalModules = await db.Modules.CountAsync(ct),
            practiceCount = practice?.count ?? 0,
            bestPracticeScore = practice?.best,
            averagePracticeScore = practice is null ? (double?)null : Math.Round(practice.avg, 1),
            nextLesson = nextLesson is null ? null : new
            {
                nextLesson.Id,
                title = Lang.Pick(xh, nextLesson.Title, nextLesson.TitleXh),
                moduleTitle = Lang.Pick(xh, nextLesson.ModuleTitle, nextLesson.ModuleTitleXh),
                courseTitle = Lang.Pick(xh, nextLesson.CourseTitle, nextLesson.CourseTitleXh),
            },
        });
    }

    private async Task<Profile> EnsureProfile(CancellationToken ct)
    {
        var userId = User.UserId();
        var profile = await db.Profiles.FirstOrDefaultAsync(p => p.Id == userId, ct);
        if (profile is not null) return profile;
        // The signup trigger normally creates this; this covers users created before it existed.
        profile = new Profile { Id = userId };
        db.Profiles.Add(profile);
        await db.SaveChangesAsync(ct);
        return profile;
    }
}
