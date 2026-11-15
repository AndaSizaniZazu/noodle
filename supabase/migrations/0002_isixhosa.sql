-- isiXhosa translations sit next to the English text. NULL = not translated yet (the API falls back to English).
-- *_xh_reviewed marks text a fluent speaker has checked; until then the app shows a "draft translation" notice.

alter table public.courses
    add column if not exists title_xh   text,
    add column if not exists summary_xh text;

alter table public.modules
    add column if not exists title_xh   text,
    add column if not exists summary_xh text;

alter table public.lessons
    add column if not exists title_xh         text,
    add column if not exists content_md_xh    text,
    add column if not exists practice_task_xh text,
    add column if not exists xh_reviewed      boolean not null default false;

alter table public.quiz_questions
    add column if not exists question_xh    text,
    add column if not exists options_xh     jsonb,
    add column if not exists explanation_xh text;

alter table public.profiles
    add column if not exists language text not null default 'en' check (language in ('en', 'xh'));

-- New sign-ups keep the language they chose on the sign-up screen.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
    insert into public.profiles (id, full_name, school, district, language)
    values (
        new.id,
        coalesce(new.raw_user_meta_data->>'full_name', ''),
        coalesce(new.raw_user_meta_data->>'school', ''),
        coalesce(new.raw_user_meta_data->>'district', ''),
        case when new.raw_user_meta_data->>'language' = 'xh' then 'xh' else 'en' end
    )
    on conflict (id) do nothing;
    return new;
end;
$$;
revoke execute on function public.handle_new_user() from public, anon, authenticated;
