-- Noodle: prompt-engineering course platform for Eastern Cape teachers.
-- The .NET API is the only reader/writer of these tables (it connects with the
-- database connection string). RLS is enabled with no policies so the public
-- Supabase anon key in the browser cannot read or write them via PostgREST.

create extension if not exists "pgcrypto";

create table public.profiles (
    id           uuid primary key references auth.users(id) on delete cascade,
    full_name    text not null default '',
    school       text not null default '',
    district     text not null default '',
    role         text not null default 'teacher' check (role in ('teacher','facilitator','admin')),
    created_at   timestamptz not null default now()
);

create table public.courses (
    id           uuid primary key default gen_random_uuid(),
    slug         text not null unique,
    title        text not null,
    summary      text not null,
    is_published boolean not null default true,
    created_at   timestamptz not null default now()
);

create table public.modules (
    id           uuid primary key default gen_random_uuid(),
    course_id    uuid not null references public.courses(id) on delete cascade,
    position     int  not null,
    title        text not null,
    summary      text not null,
    unique (course_id, position)
);

create table public.lessons (
    id           uuid primary key default gen_random_uuid(),
    module_id    uuid not null references public.modules(id) on delete cascade,
    position     int  not null,
    title        text not null,
    content_md   text not null,
    minutes      int  not null default 10,
    -- Optional hands-on task shown in the playground for this lesson
    practice_task text,
    unique (module_id, position)
);

create table public.quiz_questions (
    id            uuid primary key default gen_random_uuid(),
    module_id     uuid not null references public.modules(id) on delete cascade,
    position      int  not null,
    question      text not null,
    options       jsonb not null,          -- ["option A", "option B", ...]
    correct_index int  not null,
    explanation   text not null,
    unique (module_id, position)
);

create table public.lesson_progress (
    user_id      uuid not null references public.profiles(id) on delete cascade,
    lesson_id    uuid not null references public.lessons(id) on delete cascade,
    completed_at timestamptz not null default now(),
    primary key (user_id, lesson_id)
);

create table public.quiz_attempts (
    id           uuid primary key default gen_random_uuid(),
    user_id      uuid not null references public.profiles(id) on delete cascade,
    module_id    uuid not null references public.modules(id) on delete cascade,
    score        int  not null,
    total        int  not null,
    answers      jsonb not null,
    created_at   timestamptz not null default now()
);

create table public.playground_attempts (
    id           uuid primary key default gen_random_uuid(),
    user_id      uuid not null references public.profiles(id) on delete cascade,
    lesson_id    uuid references public.lessons(id) on delete set null,
    prompt       text not null,
    ai_response  text not null,
    feedback     jsonb not null,           -- rubric scores + tips
    total_score  int  not null,
    created_at   timestamptz not null default now()
);

create index on public.modules (course_id);
create index on public.lessons (module_id);
create index on public.quiz_questions (module_id);
create index on public.quiz_attempts (user_id, module_id);
create index on public.playground_attempts (user_id, created_at desc);

-- Create a profile row automatically when a teacher signs up.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
    insert into public.profiles (id, full_name, school, district)
    values (
        new.id,
        coalesce(new.raw_user_meta_data->>'full_name', ''),
        coalesce(new.raw_user_meta_data->>'school', ''),
        coalesce(new.raw_user_meta_data->>'district', '')
    )
    on conflict (id) do nothing;
    return new;
end;
$$;

create trigger on_auth_user_created
    after insert on auth.users
    for each row execute function public.handle_new_user();

-- Only the trigger may run this; stop it being callable via /rest/v1/rpc.
revoke execute on function public.handle_new_user() from public, anon, authenticated;

alter table public.profiles            enable row level security;
alter table public.courses             enable row level security;
alter table public.modules             enable row level security;
alter table public.lessons             enable row level security;
alter table public.quiz_questions      enable row level security;
alter table public.lesson_progress     enable row level security;
alter table public.quiz_attempts       enable row level security;
alter table public.playground_attempts enable row level security;
