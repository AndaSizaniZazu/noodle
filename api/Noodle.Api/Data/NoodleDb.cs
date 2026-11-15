using System.Text.Json;
using Microsoft.EntityFrameworkCore;

namespace Noodle.Api.Data;

// Tables are created by supabase/migrations/*.sql; EF only maps them (no EF migrations).

public class Profile
{
    public Guid Id { get; set; }
    public string FullName { get; set; } = "";
    public string School { get; set; } = "";
    public string District { get; set; } = "";
    public string Role { get; set; } = "teacher";
    public string Language { get; set; } = "en";
    public DateTimeOffset CreatedAt { get; set; }
}

public class Course
{
    public Guid Id { get; set; }
    public string Slug { get; set; } = "";
    public string Title { get; set; } = "";
    public string Summary { get; set; } = "";
    public string? TitleXh { get; set; }
    public string? SummaryXh { get; set; }
    public bool IsPublished { get; set; }
    public DateTimeOffset CreatedAt { get; set; }
    public List<Module> Modules { get; set; } = [];
}

public class Module
{
    public Guid Id { get; set; }
    public Guid CourseId { get; set; }
    public int Position { get; set; }
    public string Title { get; set; } = "";
    public string Summary { get; set; } = "";
    public string? TitleXh { get; set; }
    public string? SummaryXh { get; set; }
    public Course? Course { get; set; }
    public List<Lesson> Lessons { get; set; } = [];
    public List<QuizQuestion> QuizQuestions { get; set; } = [];
}

public class Lesson
{
    public Guid Id { get; set; }
    public Guid ModuleId { get; set; }
    public int Position { get; set; }
    public string Title { get; set; } = "";
    public string ContentMd { get; set; } = "";
    public int Minutes { get; set; }
    public string? PracticeTask { get; set; }
    public string? TitleXh { get; set; }
    public string? ContentMdXh { get; set; }
    public string? PracticeTaskXh { get; set; }
    public bool XhReviewed { get; set; }
    public Module? Module { get; set; }
}

public class QuizQuestion
{
    public Guid Id { get; set; }
    public Guid ModuleId { get; set; }
    public int Position { get; set; }
    public string Question { get; set; } = "";
    public List<string> Options { get; set; } = [];
    public int CorrectIndex { get; set; }
    public string Explanation { get; set; } = "";
    public string? QuestionXh { get; set; }
    public List<string>? OptionsXh { get; set; }
    public string? ExplanationXh { get; set; }
}

public class LessonProgress
{
    public Guid UserId { get; set; }
    public Guid LessonId { get; set; }
    public DateTimeOffset CompletedAt { get; set; }
}

public class QuizAttempt
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public Guid ModuleId { get; set; }
    public int Score { get; set; }
    public int Total { get; set; }
    public JsonDocument Answers { get; set; } = JsonDocument.Parse("[]");
    public DateTimeOffset CreatedAt { get; set; }
}

public class PlaygroundAttempt
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public Guid? LessonId { get; set; }
    public string Prompt { get; set; } = "";
    public string AiResponse { get; set; } = "";
    public JsonDocument Feedback { get; set; } = JsonDocument.Parse("{}");
    public int TotalScore { get; set; }
    public DateTimeOffset CreatedAt { get; set; }
}

public class NoodleDb(DbContextOptions<NoodleDb> options) : DbContext(options)
{
    public DbSet<Profile> Profiles => Set<Profile>();
    public DbSet<Course> Courses => Set<Course>();
    public DbSet<Module> Modules => Set<Module>();
    public DbSet<Lesson> Lessons => Set<Lesson>();
    public DbSet<QuizQuestion> QuizQuestions => Set<QuizQuestion>();
    public DbSet<LessonProgress> LessonProgress => Set<LessonProgress>();
    public DbSet<QuizAttempt> QuizAttempts => Set<QuizAttempt>();
    public DbSet<PlaygroundAttempt> PlaygroundAttempts => Set<PlaygroundAttempt>();

    protected override void OnModelCreating(ModelBuilder b)
    {
        b.HasDefaultSchema("public");
        b.Entity<Profile>().ToTable("profiles");
        b.Entity<Course>().ToTable("courses");
        b.Entity<Module>().ToTable("modules");
        b.Entity<Lesson>().ToTable("lessons");
        b.Entity<QuizQuestion>().ToTable("quiz_questions");
        var listComparer = new Microsoft.EntityFrameworkCore.ChangeTracking.ValueComparer<List<string>?>(
            (a, c) => a == null ? c == null : c != null && a.SequenceEqual(c),
            v => v == null ? 0 : v.Aggregate(0, (h, s) => HashCode.Combine(h, s.GetHashCode())),
            v => v == null ? null : v.ToList());
        foreach (var prop in new[] { nameof(QuizQuestion.Options), nameof(QuizQuestion.OptionsXh) })
        {
            b.Entity<QuizQuestion>().Property<List<string>?>(prop)
                .HasColumnType("jsonb")
                .HasConversion(
                    v => v == null ? null : JsonSerializer.Serialize(v, (JsonSerializerOptions?)null),
                    v => v == null ? null : JsonSerializer.Deserialize<List<string>>(v, (JsonSerializerOptions?)null),
                    listComparer);
        }
        b.Entity<LessonProgress>().ToTable("lesson_progress").HasKey(p => new { p.UserId, p.LessonId });
        b.Entity<QuizAttempt>().ToTable("quiz_attempts");
        b.Entity<PlaygroundAttempt>().ToTable("playground_attempts");

        foreach (var e in new[] { typeof(Profile), typeof(Course), typeof(QuizAttempt), typeof(PlaygroundAttempt) })
            b.Entity(e).Property<DateTimeOffset>("CreatedAt").HasDefaultValueSql("now()").ValueGeneratedOnAdd();
        b.Entity<LessonProgress>().Property(p => p.CompletedAt).HasDefaultValueSql("now()").ValueGeneratedOnAdd();
        foreach (var e in new[] { typeof(Course), typeof(Module), typeof(Lesson), typeof(QuizQuestion), typeof(QuizAttempt), typeof(PlaygroundAttempt) })
            b.Entity(e).Property<Guid>("Id").HasDefaultValueSql("gen_random_uuid()");
    }
}
