import { ArrowRight, BookOpen, CheckCircle2, Clock } from 'lucide-react'
import { Link } from 'react-router-dom'
import { useLang } from '../i18n/LanguageProvider'
import type { CourseListItem } from '../lib/types'
import { Card, ProgressBar, cx } from './ui'

/** One course in a list: title, size, progress and a single clear action. */
export function CourseCard({ course, compact = false }: { course: CourseListItem; compact?: boolean }) {
  const { t } = useLang()
  const done = course.lessonCount > 0 && course.completedLessons === course.lessonCount
  const started = course.completedLessons > 0
  const hours = Math.max(1, Math.round(course.minutes / 60))
  const action = done ? t('courses.review') : started ? t('courses.continue') : t('courses.start')

  return (
    <Link to={`/course/${course.slug}`} className="group block h-full rounded-2xl focus-visible:outline-3 focus-visible:outline-teal-600">
      <Card className="flex h-full flex-col transition-shadow group-hover:shadow-md group-hover:ring-teal-300">
        <div className="flex items-start gap-3">
          <span
            className={cx(
              'grid size-11 shrink-0 place-items-center rounded-xl',
              done ? 'bg-teal-600 text-white' : 'bg-amber-100 text-amber-800 dark:bg-amber-900/40 dark:text-amber-300',
            )}
            aria-hidden
          >
            {done ? <CheckCircle2 className="size-6" /> : <BookOpen className="size-6" />}
          </span>
          <div className="min-w-0">
            <h3 className="text-xl font-extrabold">{course.title}</h3>
            <p className="mt-1 flex flex-wrap gap-x-3 text-sm font-semibold text-stone-500">
              <span>{t('courses.lessons', { n: course.lessonCount })}</span>
              <span className="inline-flex items-center gap-1">
                <Clock className="size-4" aria-hidden /> {t('courses.hours', { h: hours })}
              </span>
            </p>
          </div>
        </div>
        {!compact && <p className="mt-3 text-stone-600 dark:text-stone-300">{course.summary}</p>}
        <div className="mt-auto pt-4">
          <div className="mb-1 flex justify-between text-sm font-semibold">
            <span>{done ? t('courses.finished') : t('course.lessonsDone', { done: course.completedLessons, total: course.lessonCount })}</span>
          </div>
          <ProgressBar value={course.completedLessons} max={course.lessonCount} />
          <span className="mt-4 inline-flex items-center gap-1 font-extrabold text-teal-700 group-hover:underline dark:text-teal-400">
            {action} <ArrowRight className="size-5" aria-hidden />
          </span>
        </div>
      </Card>
    </Link>
  )
}
