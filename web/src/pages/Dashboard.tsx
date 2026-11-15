import { useQuery } from '@tanstack/react-query'
import { ArrowRight, Award, BookCheck, ShieldCheck, Sparkles, Trophy } from 'lucide-react'
import type { ReactNode } from 'react'
import { CourseCard } from '../components/CourseCard'
import { ButtonLink, Card, ErrorBox, ProgressRing, Spinner } from '../components/ui'
import { useLang } from '../i18n/LanguageProvider'
import { api } from '../lib/api'
import type { CourseListItem, Me, Summary } from '../lib/types'

function Stat({ icon, label, value }: { icon: ReactNode; label: string; value: ReactNode }) {
  return (
    <Card className="flex items-center gap-4 !p-4">
      <div className="grid size-12 shrink-0 place-items-center rounded-xl bg-amber-100 text-amber-800 dark:bg-amber-900/40 dark:text-amber-300">{icon}</div>
      <div>
        <div className="text-2xl font-extrabold">{value}</div>
        <div className="text-sm text-stone-600 dark:text-stone-400">{label}</div>
      </div>
    </Card>
  )
}

export default function Dashboard() {
  const { t } = useLang()
  const me = useQuery({ queryKey: ['me'], queryFn: () => api<Me>('/api/me') })
  const summary = useQuery({ queryKey: ['summary'], queryFn: () => api<Summary>('/api/me/summary') })
  const courses = useQuery({ queryKey: ['courses'], queryFn: () => api<CourseListItem[]>('/api/courses') })

  if (summary.isPending) return <Spinner />
  if (summary.isError) return <ErrorBox message={summary.error.message} onRetry={() => summary.refetch()} />

  const s = summary.data
  const firstName = me.data?.fullName.split(' ')[0] || ''
  const allDone = s.totalLessons > 0 && s.completedLessons === s.totalLessons && s.quizzesPassed === s.totalModules
  const started = s.completedLessons > 0

  return (
    <div className="animate-fade-up space-y-6">
      <div>
        <h1 className="text-3xl font-extrabold md:text-4xl">{t('dash.hello', { name: firstName })}</h1>
        <p className="mt-1 text-lg text-stone-600 dark:text-stone-300">{t(allDone ? 'dash.allDone' : started ? 'dash.ready' : 'dash.firstStep')}</p>
      </div>

      <div className="grid gap-4 md:grid-cols-[1fr_auto]">
        {allDone ? (
          <Card className="bg-gradient-to-br from-amber-50 to-teal-50 text-center dark:from-amber-950/40 dark:to-teal-950/40">
            <Award className="mx-auto size-16 text-amber-500" aria-hidden />
            <h2 className="mt-2 text-2xl font-extrabold">{t('dash.courseComplete')}</h2>
            <p className="mt-1 text-stone-600 dark:text-stone-300">{t('dash.completed', { name: me.data?.fullName ?? '' })}</p>
            <ButtonLink to="/playground" className="mt-5">
              {t('dash.keepPractising')}
            </ButtonLink>
          </Card>
        ) : s.nextLesson ? (
          <Card className="bg-teal-700 text-white ring-0 dark:bg-teal-800">
            <p className="text-sm font-bold tracking-wide text-teal-100 uppercase">{t(started ? 'dash.continueWhere' : 'dash.startHere')}</p>
            <h2 className="mt-2 text-2xl font-extrabold">{s.nextLesson.title}</h2>
            <p className="mt-1 text-teal-100">
              {s.nextLesson.courseTitle} · {s.nextLesson.moduleTitle}
            </p>
            <ButtonLink to={`/lessons/${s.nextLesson.id}`} variant="accent" className="mt-5">
              {t(started ? 'dash.continueLesson' : 'dash.startLesson')} <ArrowRight className="size-5" aria-hidden />
            </ButtonLink>
          </Card>
        ) : (
          <Card>
            <h2 className="text-xl font-extrabold">{t('dash.lessonsDone')}</h2>
            <p className="mt-1">{t('dash.finishQuizzes')}</p>
            <ButtonLink to="/course" className="mt-4">
              {t('dash.goQuizzes')}
            </ButtonLink>
          </Card>
        )}

        <Card className="flex flex-col items-center justify-center">
          <ProgressRing value={s.completedLessons} max={s.totalLessons}>
            <div>
              <div className="text-2xl font-extrabold">
                {s.completedLessons}/{s.totalLessons}
              </div>
              <div className="text-xs text-stone-500">{t('dash.lessons')}</div>
            </div>
          </ProgressRing>
          <p className="mt-2 text-sm font-semibold text-stone-600 dark:text-stone-400">{t('dash.progress')}</p>
        </Card>
      </div>

      <div className="grid gap-4 sm:grid-cols-3">
        <Stat icon={<BookCheck className="size-6" />} label={t('dash.quizzesPassed')} value={`${s.quizzesPassed}/${s.totalModules}`} />
        <Stat icon={<Sparkles className="size-6" />} label={t('dash.promptsPractised')} value={s.practiceCount} />
        <Stat icon={<Trophy className="size-6" />} label={t('dash.bestScore')} value={s.bestPracticeScore != null ? `${s.bestPracticeScore}/10` : '—'} />
      </div>

      {courses.data && courses.data.length > 1 && (
        <section aria-labelledby="your-courses" className="space-y-3">
          <div className="flex items-baseline justify-between gap-3">
            <h2 id="your-courses" className="text-xl font-extrabold">
              {t('courses.yours')}
            </h2>
            <ButtonLink to="/course" variant="ghost">
              {t('courses.seeAll')}
            </ButtonLink>
          </div>
          <ul className="grid gap-4 md:grid-cols-2">
            {courses.data.map((c) => (
              <li key={c.id}>
                <CourseCard course={c} compact />
              </li>
            ))}
          </ul>
        </section>
      )}

      <Card className="flex items-start gap-4">
        <ShieldCheck className="size-8 shrink-0 text-teal-700 dark:text-teal-400" aria-hidden />
        <div>
          <h2 className="font-extrabold">{t('dash.golden')}</h2>
          <p className="text-stone-600 dark:text-stone-300">{t('dash.goldenText')}</p>
        </div>
      </Card>
    </div>
  )
}
