# Saves the Noodle API's secrets with dotnet user-secrets (stored outside the repo).
# You type the values here; they are never written to any project file.
$ErrorActionPreference = 'Stop'
$project = Join-Path $PSScriptRoot '..\api\Noodle.Api'

function Read-Secret([string]$prompt) {
    $secure = Read-Host -Prompt $prompt -AsSecureString
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try { [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
}

$dbPassword = Read-Secret 'Supabase database password (BuntuAI project)'
if ($dbPassword) {
    # Npgsql keyword format: no URL-encoding needed; quote the password so ; and = are safe.
    $escaped = $dbPassword.Replace("'", "''")
    $conn = "Host=aws-0-eu-west-1.pooler.supabase.com;Port=5432;Database=postgres;" +
            "Username=postgres.tbfzhvnxihujtgsjvrpz;Password='$escaped';SSL Mode=Require;Trust Server Certificate=true"
    dotnet user-secrets set 'ConnectionStrings:Supabase' $conn --project $project | Out-Null
    Write-Host 'Saved database connection.' -ForegroundColor Green
}

$orKey = Read-Secret 'OpenRouter API key (press Enter to skip)'
if ($orKey) {
    dotnet user-secrets set 'OpenRouter:ApiKey' $orKey --project $project | Out-Null
    Write-Host 'Saved OpenRouter key.' -ForegroundColor Green
}

Write-Host 'Done. Secrets set:' -ForegroundColor Cyan
dotnet user-secrets list --project $project | ForEach-Object { ($_ -split ' = ')[0] }
