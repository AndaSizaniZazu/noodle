#:package Npgsql@10.0.0
#:property PublishAot=false
// Runs a .sql file against the Supabase database using the API's saved connection string
// (from dotnet user-secrets). Usage:  dotnet run scripts/apply-sql.cs -- supabase/seed.sql
using System.Text.Json;
using Npgsql;

if (args.Length != 1 || !File.Exists(args[0]))
{
    Console.Error.WriteLine("Usage: dotnet run scripts/apply-sql.cs -- <file.sql>");
    return 1;
}

const string userSecretsId = "2c20609d-9154-4c61-bf25-7620e690f778"; // from api/Noodle.Api/Noodle.Api.csproj
var secretsPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
    "Microsoft", "UserSecrets", userSecretsId, "secrets.json");
if (!File.Exists(secretsPath))
{
    Console.Error.WriteLine("No API secrets found. Run scripts/set-secrets.ps1 first.");
    return 1;
}

using var secrets = JsonDocument.Parse(File.ReadAllText(secretsPath));
if (!secrets.RootElement.TryGetProperty("ConnectionStrings:Supabase", out var cs))
{
    Console.Error.WriteLine("ConnectionStrings:Supabase is not set. Run scripts/set-secrets.ps1 first.");
    return 1;
}

var sql = File.ReadAllText(args[0]);
await using var conn = new NpgsqlConnection(cs.GetString());
await conn.OpenAsync();
await using var tx = await conn.BeginTransactionAsync();
await using (var cmd = new NpgsqlCommand(sql, conn, tx))
{
    cmd.CommandTimeout = 120;
    await cmd.ExecuteNonQueryAsync();
}
await tx.CommitAsync();
Console.WriteLine($"Applied {Path.GetFileName(args[0])}.");
return 0;
