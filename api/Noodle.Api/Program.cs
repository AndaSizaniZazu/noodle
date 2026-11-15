using Anthropic;
using Microsoft.EntityFrameworkCore;
using Noodle.Api.Auth;
using Noodle.Api.Data;
using Noodle.Api.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddProblemDetails();

// The Supabase pooler occasionally times out on new connections: allow a longer connect
// timeout and let EF retry transient failures instead of failing the teacher's request.
var dbConnection = new Npgsql.NpgsqlConnectionStringBuilder(builder.Configuration.GetConnectionString("Supabase")
    ?? throw new InvalidOperationException("ConnectionStrings:Supabase is not configured"))
{
    Timeout = 30,
    KeepAlive = 30,
}.ConnectionString;
builder.Services.AddDbContext<NoodleDb>(o => o
    .UseNpgsql(dbConnection, npgsql => npgsql.EnableRetryOnFailure(maxRetryCount: 3))
    .UseSnakeCaseNamingConvention());

builder.Services.AddSupabaseAuth(builder.Configuration);

// AI provider for the Playground: OpenRouter when OpenRouter:ApiKey is set, otherwise the
// Claude API directly (Anthropic:ApiKey or the ANTHROPIC_API_KEY env var).
if (builder.Configuration["OpenRouter:ApiKey"] is { Length: > 0 })
{
    builder.Services.AddHttpClient<IChatModel, OpenRouterChatModel>((sp, http) =>
        OpenRouterChatModel.Configure(http, sp.GetRequiredService<IConfiguration>()));
}
else
{
    builder.Services.AddSingleton(_ => new AnthropicClient
    {
        ApiKey = builder.Configuration["Anthropic:ApiKey"] is { Length: > 0 } key
            ? key
            : Environment.GetEnvironmentVariable("ANTHROPIC_API_KEY"),
    });
    builder.Services.AddScoped<IChatModel, AnthropicChatModel>();
}
builder.Services.AddScoped<PromptCoach>();

var origins = builder.Configuration.GetSection("Cors:Origins").Get<string[]>() ?? [];
builder.Services.AddCors(o => o.AddDefaultPolicy(p => p
    .WithOrigins(origins)
    .SetIsOriginAllowedToAllowWildcardSubdomains()
    .AllowAnyHeader()
    .AllowAnyMethod()));

var app = builder.Build();

app.UseExceptionHandler();
app.UseCors();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.Run();

public partial class Program;
