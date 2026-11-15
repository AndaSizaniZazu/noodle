import { useQuery } from '@tanstack/react-query'
import { CheckCircle2, Circle, ClipboardCheck, Clock } from 'lucide-react'
import { Link, Navigate, useParams } from 'react-router-dom'
import { CourseCard } from '../components/CourseCard'
import { ButtonLink, Card, ErrorBox, ProgressBar, Spinner, cx } from '../components/ui'
import { useLang } from '../i18n/LanguageProvider'
import { api } from '../lib/api'
import type { CourseListItem, CourseOutline } from '../lib/types'

/** /course → all courses; goes straight into the course when there is only one. */
export function CourseIndex() {
  const { t } = useLang()
  const courses = useQuery({ queryKey: ['courses'], queryFn: () => api<CourseListItem[]>('/api/courses') })
  if (courses.isPending) return <Spinner />
  if (courses.isError) return <ErrorBox message={courses.error.message} onRetry={() => courses.refetch()} />
  if (courses.data.length === 0) return <ErrorBox message={t('course.none')} />
  if (courses.data.length === 1) return <Navigate to={`/course/${courses.data[0].slug}`} replace />
  return (
    <div className="animate-fade-up space-y-6">
      <header>
        <h1 className="text-3xl font-extrabold md:text-4xl">{t('courses.title')}</h1>
        <p className="mt-2 max-w-2xl text-lg text-stone-600 dark:text-stone-300">{t('courses.intro')}</p>
      </header>
      <ul className="grid gap-4 md:grid-cols-2">
        {courses.data.map((c) => (
          <li key={c.id}>
            <CourseCard course={c} />
          </li>
        ))}
      </ul>
    </div>
  )
}

export default function Course() {
  const { slug = '' } = useParams()
  const { t } = useLang()
  const course = useQuery({ queryKey: ['course', slug], queryFn: () => api<CourseOutline>(`/api/courses/${slug}`) })

  if (course.isPending) return <Spinner />
  if (course.isError) return <ErrorBox message={course.error.message} onRetry={() => course.refetch()} />

  const c = course.data
  const all = c.modules.flatMap((m) => m.lessons)
  const done = all.filter((l) => l.completed).length

  return (
    <div className="animate-fade-up space-y-6">
      <header>
        <h1 className="text-3xl font-extrabold md:text-4xl">{c.title}</h1>
        <p className="mt-2 max-w-2xl text-lg text-stone-600 dark:text-stone-300">{c.summary}</p>
        <div className="mt-4 max-w-md">
          <div className="mb-1 flex justify-between text-sm font-semibold">
            <span>{t('course.lessonsDone', { done, total: all.length })}</span>
            <span>{all.length ? Math.round((done / all.length) * 100) : 0}%</span>
          </div>
          <ProgressBar value={done} max={all.length} />
        </div>
      </header>

      <ol className="space-y-4">
        {c.modules.map((m) => {
          const mDone = m.lessons.filter((l) => l.completed).length
          const lessonsDone = mDone === m.lessons.length
          const passed = m.bestQuizScore != null && m.bestQuizScore * 100 >= m.questionCount * 70
          return (
            <li key={m.id}>
              <Card>
                <div className="flex items-start gap-4">
                  <span
                    className={cx(
                      'grid size-11 shrink-0 place-items-center rounded-full text-lg font-extrabold',
                      lessonsDone && passed ? 'bg-teal-600 text-white' : 'bg-amber-500 text-stone-900',
                    )}
                    aria-hidden
                  >
                    {lessonsDone && passed ? '✓' : m.position}
                  </span>
                  <div className="min-w-0 flex-1">
                    <p className="text-sm font-bold text-stone-500">{t('course.module', { n: m.position })}</p>
                    <h2 className="text-xl font-extrabold">{m.title}</h2>
                    <p className="mt-1 text-stone-600 dark:text-stone-300">{m.summary}</p>
                    <div className="mt-3">
                      <ProgressBar value={mDone} max={m.lessons.length} />
                    </div>
                  </div>
                </div>

                <ul className="mt-4 divide-y divide-stone-100 dark:divide-stone-800">
                  {m.lessons.map((l) => (
                    <li key={l.id}>
                      <Link to={`/lessons/${l.id}`} className="flex min-h-14 items-center gap-3 rounded-xl px-2 hover:bg-stone-50 dark:hover:bg-stone-800">
                        {l.completed ? (
                          <CheckCircle2 className="size-6 shrink-0 text-teal-600" aria-label={t('course.completed')} />
                        ) : (
                          <Circle className="size-6 shrink-0 text-stone-300" aria-label={t('course.notStarted')} />
                        )}
                        <span className="flex-1 font-semibold">{l.title}</span>
                        <span className="flex items-center gap-1 text-sm whitespace-nowrap text-stone-500">
                          <Clock className="size-4" aria-hidden /> {l.minutes} {t('common.min')}
                        </span>
                      </Link>
                    </li>
                  ))}
                </ul>

                <div className="mt-4 flex flex-wrap items-center gap-3 border-t border-stone-100 pt-4 dark:border-stone-800">
                  <ButtonLink to={`/quiz/${m.id}`} variant={lessonsDone ? 'primary' : 'secondary'}>
                    <ClipboardCheck className="size-5" aria-hidden />
                    {t(m.bestQuizScore != null ? 'course.retakeQuiz' : 'course.takeQuiz')}
                  </ButtonLink>
                  {m.bestQuizScore != null && (
                    <span className={cx('font-semibold', passed ? 'text-teal-700 dark:text-teal-400' : 'text-amber-700 dark:text-amber-400')}>
                      {t('course.best', { score: m.bestQuizScore, total: m.questionCount })} {passed ? `· ${t('course.passed')}` : ''}
                    </span>
                  )}
                </div>
              </Card>
            </li>
          )
        })}
      </ol>
    </div>
  )
}
