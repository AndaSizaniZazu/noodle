using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Noodle.Api.Auth;
using Noodle.Api.Data;

namespace Noodle.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/courses")]
public class CoursesController(NoodleDb db) : ControllerBase
{
    /// <summary>All published courses with the signed-in teacher's progress.</summary>
    [HttpGet]
    public async Task<IActionResult> List(CancellationToken ct)
    {
        var userId = User.UserId();
        var done = await db.LessonProgress.Where(p => p.UserId == userId).Select(p => p.LessonId).ToListAsync(ct);

        var courses = await db.Courses.AsNoTracking()
            .Where(c => c.IsPublished)
            .Include(c => c.Modules).ThenInclude(m => m.Lessons)
            .OrderBy(c => c.CreatedAt)
            .ToListAsync(ct);

        var xh = Request.IsXh();
        return Ok(courses.Select(c =>
        {
            var lessonIds = c.Modules.SelectMany(m => m.Lessons).Select(l => l.Id).ToList();
            return new
            {
                c.Id, c.Slug,
                title = Lang.Pick(xh, c.Title, c.TitleXh),
                summary = Lang.Pick(xh, c.Summary, c.SummaryXh),
                moduleCount = c.Modules.Count,
                lessonCount = lessonIds.Count,
                completedLessons = lessonIds.Count(done.Contains),
                minutes = c.Modules.SelectMany(m => m.Lessons).Sum(l => l.Minutes),
            };
        }));
    }

    /// <summary>Course outline: modules, lessons (no content), completion and best quiz score.</summary>
    [HttpGet("{slug}")]
    public async Task<IActionResult> Get(string slug, CancellationToken ct)
    {
        var userId = User.UserId();
        var course = await db.Courses.AsNoTracking()
            .Include(c => c.Modules).ThenInclude(m => m.Lessons)
            .Include(c => c.Modules).ThenInclude(m => m.QuizQuestions)
            .FirstOrDefaultAsync(c => c.Slug == slug && c.IsPublished, ct);
        if (course is null) return NotFound();

        var done = (await db.LessonProgress.Where(p => p.UserId == userId).Select(p => p.LessonId).ToListAsync(ct)).ToHashSet();
        var moduleIds = course.Modules.Select(m => m.Id).ToList();
        var best = await db.QuizAttempts
            .Where(a => a.UserId == userId && moduleIds.Contains(a.ModuleId))
            .GroupBy(a => a.ModuleId)
            .Select(g => new { ModuleId = g.Key, Score = g.Max(a => a.Score), Total = g.Max(a => a.Total) })
            .ToDictionaryAsync(x => x.ModuleId, ct);

        var xh = Request.IsXh();
        return Ok(new
        {
            course.Id, course.Slug,
            title = Lang.Pick(xh, course.Title, course.TitleXh),
            summary = Lang.Pick(xh, course.Summary, course.SummaryXh),
            modules = course.Modules.OrderBy(m => m.Position).Select(m => new
            {
                m.Id, m.Position,
                title = Lang.Pick(xh, m.Title, m.TitleXh),
                summary = Lang.Pick(xh, m.Summary, m.SummaryXh),
                questionCount = m.QuizQuestions.Count,
                bestQuizScore = best.TryGetValue(m.Id, out var b) ? b.Score : (int?)null,
                lessons = m.Lessons.OrderBy(l => l.Position).Select(l => new
                {
                    l.Id, l.Position, l.Minutes,
                    title = Lang.Pick(xh, l.Title, l.TitleXh),
                    completed = done.Contains(l.Id),
                }),
            }),
        });
    }

    /// <summary>One lesson with its content, plus previous/next lesson ids for navigation.</summary>
    [HttpGet("lessons/{lessonId:guid}")]
    public async Task<IActionResult> Lesson(Guid lessonId, CancellationToken ct)
    {
        var userId = User.UserId();
        var lesson = await db.Lessons.AsNoTracking()
            .Include(l => l.Module).ThenInclude(m => m!.Course)
            .FirstOrDefaultAsync(l => l.Id == lessonId, ct);
        if (lesson?.Module?.Course is null) return NotFound();

        var ordered = await db.Lessons.AsNoTracking()
            .Where(l => l.Module!.CourseId == lesson.Module.CourseId)
            .OrderBy(l => l.Module!.Position).ThenBy(l => l.Position)
            .Select(l => l.Id)
            .ToListAsync(ct);
        var i = ordered.IndexOf(lesson.Id);
        var completed = await db.LessonProgress.AnyAsync(p => p.UserId == userId && p.LessonId == lessonId, ct);

        var xh = Request.IsXh();
        var hasXh = !string.IsNullOrWhiteSpace(lesson.ContentMdXh);
        return Ok(new
        {
            lesson.Id, lesson.Minutes, completed,
            title = Lang.Pick(xh, lesson.Title, lesson.TitleXh),
            contentMd = Lang.Pick(xh, lesson.ContentMd, lesson.ContentMdXh),
            practiceTask = Lang.PickOptional(xh, lesson.PracticeTask, lesson.PracticeTaskXh),
            // "translated": isiXhosa was asked for and exists; "draftTranslation": not yet checked by a fluent speaker.
            translated = xh && hasXh,
            draftTranslation = xh && hasXh && !lesson.XhReviewed,
            module = new { lesson.Module.Id, lesson.Module.Position, title = Lang.Pick(xh, lesson.Module.Title, lesson.Module.TitleXh) },
            course = new { lesson.Module.Course.Slug, title = Lang.Pick(xh, lesson.Module.Course.Title, lesson.Module.Course.TitleXh) },
            previousLessonId = i > 0 ? ordered[i - 1] : (Guid?)null,
            nextLessonId = i < ordered.Count - 1 ? ordered[i + 1] : (Guid?)null,
            isLastInModule = !await db.Lessons.AnyAsync(l => l.ModuleId == lesson.ModuleId && l.Position > lesson.Position, ct),
        });
    }

    [HttpPost("lessons/{lessonId:guid}/complete")]
    public async Task<IActionResult> Complete(Guid lessonId, CancellationToken ct)
    {
        var userId = User.UserId();
        if (!await db.Lessons.AnyAsync(l => l.Id == lessonId, ct)) return NotFound();
        if (!await db.LessonProgress.AnyAsync(p => p.UserId == userId && p.LessonId == lessonId, ct))
        {
            db.LessonProgress.Add(new LessonProgress { UserId = userId, LessonId = lessonId });
            await db.SaveChangesAsync(ct);
        }
        return NoContent();
    }
}
