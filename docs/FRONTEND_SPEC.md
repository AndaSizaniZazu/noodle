# Lovable brief — Noodle frontend

Paste this into Lovable (or Claude sends it via the Lovable MCP).

---

Build **Noodle**, a friendly learning website that teaches teachers in the **Eastern Cape Department of Education (South Africa)** the basics of prompt engineering (how to write good instructions for AI tools).

## Who uses it
Teachers aged 25–60, many new to AI, often on **mobile phones with slow or expensive data**, some with English as a second language (isiXhosa home language). The UI must feel calm, encouraging and very easy — never technical.

## Tech
- React + TypeScript + Tailwind + shadcn/ui (Lovable defaults), react-router, @tanstack/react-query, react-markdown with remark-gfm (lessons are Markdown with tables).
- **Auth: Supabase Auth** (email + password, plus "forgot password"). Use `@supabase/supabase-js` with env vars `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`. Sign-up collects `full_name`, `school`, `district` as user metadata.
- **All data comes from our .NET API**, NOT from Supabase tables directly. Base URL env var `VITE_API_URL`. Send `Authorization: Bearer <supabase access_token>` on every request. Create one `api.ts` helper that attaches the token and shows API `{ error }` messages in a friendly toast.

## API (all JSON, all need the bearer token except /api/districts)
| Method | Path | Returns / body |
|---|---|---|
| GET | `/api/districts` | `string[]` — 12 Eastern Cape districts for a dropdown |
| GET | `/api/me` | `{ id, email, fullName, school, district, role }` |
| PUT | `/api/me` | body `{ fullName, school, district }` |
| GET | `/api/me/summary` | `{ totalLessons, completedLessons, totalModules, quizzesPassed, practiceCount, bestPracticeScore, averagePracticeScore, nextLesson: { id, title, moduleTitle } \| null }` |
| GET | `/api/courses` | `[{ id, slug, title, summary, moduleCount, lessonCount, completedLessons, minutes }]` |
| GET | `/api/courses/{slug}` | `{ id, slug, title, summary, modules: [{ id, position, title, summary, questionCount, bestQuizScore, lessons: [{ id, position, title, minutes, completed }] }] }` |
| GET | `/api/courses/lessons/{lessonId}` | `{ id, title, contentMd, minutes, practiceTask, completed, module: { id, title, position }, course: { slug, title }, previousLessonId, nextLessonId, isLastInModule }` |
| POST | `/api/courses/lessons/{lessonId}/complete` | 204 |
| GET | `/api/modules/{moduleId}/quiz` | `{ id, title, position, questions: [{ id, question, options: string[] }] }` |
| POST | `/api/modules/{moduleId}/quiz` | body `{ answers: number[] }` → `{ score, total, passed, results: [{ questionId, chosen, correctIndex, correct, explanation }] }` |
| GET | `/api/playground/usage` | `{ used, limit, remaining }` |
| POST | `/api/playground` | body `{ prompt, lessonId? }` → `{ id, aiResponse, total, outOf, feedback: { role, task, context, format, constraints (each 0–2), privacy_concern, summary, strengths[], improvements[], improved_prompt } }`. Can take 20–60 s. Errors: 422 (blocked for privacy/refusal), 429 (daily limit), 503 (AI busy) — show the `error` text kindly. |
| GET | `/api/playground/history` | last 20 attempts `[{ id, prompt, aiResponse, feedback, totalScore, createdAt, lessonId }]` |

## Pages
1. **Welcome (public)** — warm hero: "Learn to use AI as your teaching assistant." Three benefit cards (Save planning time · Make better worksheets · Stay in control & protect learners). Big "Start learning — it's free" button. Short "What you'll learn" list of the 6 modules. Footer: "For Eastern Cape Department of Education teachers".
2. **Sign up / Sign in** — single simple card, big inputs, show-password toggle, district dropdown from `/api/districts`. Clear, friendly error messages.
3. **My learning (dashboard)** — greeting "Molo, {first name}!", one big **Continue** card pointing at `nextLesson`, a progress ring (completed/total lessons), small stat tiles (quizzes passed, practice prompts tried, best prompt score /10). If all done: celebration + certificate-style badge.
4. **Course page** — vertical list of 6 modules as cards with step numbers, progress bar per module, lessons with ✓ ticks and minutes, and a "Take the quiz" button per module (shows best score if any).
5. **Lesson page** — clean reading layout (max ~70ch, 18px text, generous line height), breadcrumb, estimated minutes, Markdown content (style tables and blockquotes nicely — blockquotes are example prompts: show them as a soft card with a **Copy** button). At the bottom: "Try it yourself" box showing `practiceTask` with button **Practise in the Playground** (opens playground with lessonId). Then **Mark as done & continue** → posts complete and goes to next lesson, or to the quiz if `isLastInModule`.
6. **Quiz page** — one question at a time on mobile, large tappable option cards, progress dots, then a results screen with score, a friendly message (≥70% "Well done!", else "Good try — review and try again"), and each question's explanation with correct/incorrect colouring.
7. **Prompt Playground** — the heart of the app.
   - Top: the practice task (if any) and a banner: "🔒 Never type learners' names, ID numbers or marks."
   - A large textarea with placeholder showing an RTCF example, a live character count, and four helper **chips** (Role, Task, Context, Format) that insert starter text like "You are a…".
   - "Remaining tries today: X of Y".
   - On submit: friendly loading state with rotating tips ("Tip: add your class size and resources for better answers") because it can take up to a minute.
   - Result in two panels (tabs on mobile): **AI's answer** (rendered Markdown) and **Your coach's feedback**: score out of 10 as a big friendly dial, five criteria as labelled bars (Role, Task, Context, Format, Constraints — 0/1/2), summary, ✅ strengths, 💡 improvements, privacy warning if `privacy_concern`, and the **improved prompt** in a card with **Copy** and **Try this version** (puts it back into the textarea).
   - "My past prompts" list from history (expandable).
8. **Profile** — edit name, school, district; sign out.

## Design
- Friendly, calm, professional. Primary colour deep teal/green (#0F766E), warm accent ochre (#D97706), off-white background, plenty of white space, rounded-2xl cards, soft shadows.
- Font: Inter or Nunito, base 17–18px; headings clear and short.
- **Mobile-first**: bottom navigation bar on phones (Home, Course, Playground, Profile); top nav on desktop.
- Accessibility: WCAG AA contrast, visible focus rings, buttons ≥ 44px tall, labels on every input, no information only by colour.
- Low-data friendly: no heavy images or video; use simple icons (lucide) and small illustrations only.
- Plain, encouraging language everywhere. No jargon. Empty states and errors always tell the teacher what to do next.
- Light and dark mode.
