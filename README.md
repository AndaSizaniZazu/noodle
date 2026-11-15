# Noodle — Prompt engineering for Eastern Cape teachers

A small learning platform (Moodle-style) that teaches teachers the basics of prompt engineering, with lessons, quizzes and an AI **Prompt Playground** that coaches teachers on their prompts.

| Part | Tech | Folder |
|---|---|---|
| Database + sign-in | Supabase (Postgres + Supabase Auth) | `supabase/` |
| Backend API | ASP.NET Core (.NET 10), EF Core + Npgsql, Claude API | `api/` |
| Frontend | React + TypeScript (Vite, Tailwind, React Query) | `web/` (spec: `docs/FRONTEND_SPEC.md`) |

## 1. Supabase
1. Create a project at supabase.com.
2. SQL Editor → run `supabase/migrations/0001_schema.sql` and `0002_isixhosa.sql`, then the courses: `supabase/seed.sql` (AI Prompting for Teachers, 8 modules), `supabase/seed-lesson-prep.sql` (Planning Lessons with AI: Grade R to 7, 30 lessons) and `supabase/seed-lesson-prep-8-12.sql` (Planning Lessons with AI: Grade 8 to 12, 30 lessons). Or from the repo root: `dotnet run scripts/apply-sql.cs -- supabase/seed-lesson-prep.sql`. Then `dotnet run scripts/translate-xh.cs` drafts isiXhosa for anything new.
3. Note from Project Settings: **Project URL**, **anon key** (frontend), and the **database connection string** (Connect → .NET / Npgsql; use the Session pooler on IPv4 networks).

RLS is on for every table with no policies: only the .NET API (via the DB connection) reads/writes data, so the public anon key cannot.

## 2. API
```bash
cd api/Noodle.Api
dotnet user-secrets init
dotnet user-secrets set "ConnectionStrings:Supabase" "Host=...;Port=5432;Database=postgres;Username=...;Password=...;SSL Mode=Require"
dotnet user-secrets set "Supabase:Url" "https://<project-ref>.supabase.co"
dotnet user-secrets set "Anthropic:ApiKey" "<your Anthropic API key>"
dotnet run
```
- Only set `Supabase:JwtSecret` if your project still uses the legacy HS256 JWT secret; otherwise tokens are checked against the project's JWKS.
- `Playground:DailyLimit` (default 20) caps AI practice tries per teacher per day, to control cost.
- Add your deployed frontend URL to `Cors:Origins`.

The playground uses `claude-opus-5-5` with server-side refusal fallback enabled; each try makes two calls (the answer, then the coaching feedback).

## 3. Frontend
```bash
cd web
cp .env.example .env.local   # fill in Supabase URL, anon key and API URL
npm install
npm run dev                  # http://localhost:5173
```
In Supabase → Authentication → URL Configuration, add `http://localhost:5173` (and your live URL) as the Site URL / redirect URLs so the sign-up and password-reset emails link back to the app.

Pages: welcome, sign up / sign in / forgot password, dashboard, course outline, lessons (example prompts have a Copy button), one-question-at-a-time quizzes, Prompt Playground with coach feedback, and profile. Mobile-first with a bottom tab bar; signed-in pages are loaded on demand to save data.

## 4. Tests
```bash
dotnet test
```

## Deploying

- **Website → GitHub Pages.** `.github/workflows/pages.yml` builds `web/` on every push to `master` and publishes it to
  `https://<user>.github.io/noodle/`. It reads the repository variables `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`
  (the public publishable key) and `VITE_API_URL` (the Render URL). Settings → Pages → Source must be "GitHub Actions".
- **API → Render.** `render.yaml` is a Render Blueprint (Docker, `api/Dockerfile`). In Render choose New → Blueprint and
  pick this repo, then enter the two secrets when asked: `ConnectionStrings__Supabase` (same value as the user-secret)
  and `OpenRouter__ApiKey`. Render redeploys when `api/` changes. The free plan sleeps after 15 minutes idle.
- **CORS.** The Pages origin must be in `Cors:Origins` in `api/Noodle.Api/appsettings.json`.
- **Supabase Auth.** Authentication → URL Configuration: set Site URL to the Pages URL and add
  `https://<user>.github.io/noodle/**` to Redirect URLs, so sign-up and password-reset emails link to the live site.
