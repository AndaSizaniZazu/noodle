import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { ArrowLeft, ArrowRight, CheckCircle2, ChevronRight, Clock, Info, Sparkles } from 'lucide-react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { Markdown } from '../components/Markdown'
import { Button, ButtonLink, Card, ErrorBox, Spinner, useToast } from '../components/ui'
import { useLang } from '../i18n/LanguageProvider'
import { api } from '../lib/api'
import type { LessonDetail } from '../lib/types'

export default function Lesson() {
  const { lessonId = '' } = useParams()
  const navigate = useNavigate()
  const toast = useToast()
  const { t, lang, setLang } = useLang()
  const qc = useQueryClient()
  const lesson = useQuery({ queryKey: ['lesson', lessonId], queryFn: () => api<LessonDetail>(`/api/courses/lessons/${lessonId}`) })

  const complete = useMutation({
    mutationFn: () => api<void>(`/api/courses/lessons/${lessonId}/complete`, { method: 'POST' }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['summary'] })
      qc.invalidateQueries({ queryKey: ['course'] })
      qc.invalidateQueries({ queryKey: ['courses'] })
      qc.invalidateQueries({ queryKey: ['lesson', lessonId] })
      const l = lesson.data!
      if (l.isLastInModule) {
        toast(t('lesson.doneQuizToast'), 'success')
        navigate(`/quiz/${l.module.id}`)
      } else if (l.nextLessonId) {
        toast(t('lesson.doneToast'), 'success')
        navigate(`/lessons/${l.nextLessonId}`)
      }
      window.scrollTo({ top: 0 })
    },
    onError: (e) => toast(e.message),
  })

  if (lesson.isPending) return <Spinner label={t('lesson.opening')} />
  if (lesson.isError) return <ErrorBox message={lesson.error.message} onRetry={() => lesson.refetch()} />
  const l = lesson.data

  return (
    <article className="animate-fade-up mx-auto max-w-3xl" lang={l.translated ? 'xh' : 'en'}>
      <nav aria-label="Breadcrumb" className="mb-4 flex flex-wrap items-center gap-1 text-sm font-semibold text-stone-500">
        <Link to={`/course/${l.course.slug}`} className="hover:text-teal-700 hover:underline">
          {t('lesson.course')}
        </Link>
        <ChevronRight className="size-4" aria-hidden />
        <span>
          {t('course.module', { n: l.module.position })}: {l.module.title}
        </span>
      </nav>

      <header className="mb-6">
        <h1 className="text-3xl font-extrabold md:text-4xl">{l.title}</h1>
        <p className="mt-2 flex items-center gap-3 text-stone-500">
          <span className="flex items-center gap-1">
            <Clock className="size-4" aria-hidden /> {t('lesson.minRead', { n: l.minutes })}
          </span>
          {l.completed && (
            <span className="flex items-center gap-1 font-semibold text-teal-700 dark:text-teal-400">
              <CheckCircle2 className="size-4" aria-hidden /> {t('lesson.done')}
            </span>
          )}
        </p>
      </header>

      {lang === 'xh' && (l.draftTranslation || !l.translated) && (
        <div role="note" className="mb-5 flex items-start gap-3 rounded-2xl bg-sky-50 p-4 text-sky-900 ring-1 ring-sky-200 dark:bg-sky-950/40 dark:text-sky-100 dark:ring-sky-900">
          <Info className="mt-0.5 size-5 shrink-0" aria-hidden />
          <div className="space-y-2">
            <p>{t(l.translated ? 'lesson.draftXh' : 'lesson.notTranslated')}</p>
            {l.translated && (
              <button type="button" onClick={() => setLang('en')} className="font-bold underline">
                English
              </button>
            )}
          </div>
        </div>
      )}

      <Card className="!p-5 sm:!p-8">
        <Markdown className="text-[1.05rem] leading-relaxed">{l.contentMd}</Markdown>
      </Card>

      {l.practiceTask && (
        <Card className="mt-6 bg-amber-50 ring-amber-200 dark:bg-amber-950/30 dark:ring-amber-900">
          <h2 className="flex items-center gap-2 text-lg font-extrabold text-amber-900 dark:text-amber-200">
            <Sparkles className="size-5" aria-hidden /> {t('lesson.tryIt')}
          </h2>
          <p className="mt-2">{l.practiceTask}</p>
          <ButtonLink to={`/playground?lesson=${l.id}`} variant="accent" className="mt-4">
            {t('lesson.practise')}
          </ButtonLink>
        </Card>
      )}

      <div className="mt-8 flex flex-col-reverse gap-3 sm:flex-row sm:items-center sm:justify-between">
        {l.previousLessonId ? (
          <ButtonLink to={`/lessons/${l.previousLessonId}`} variant="ghost">
            <ArrowLeft className="size-5" aria-hidden /> {t('common.previous')}
          </ButtonLink>
        ) : (
          <span />
        )}
        {l.completed && !l.isLastInModule && l.nextLessonId ? (
          <ButtonLink to={`/lessons/${l.nextLessonId}`}>
            {t('lesson.next')} <ArrowRight className="size-5" aria-hidden />
          </ButtonLink>
        ) : l.completed && l.isLastInModule ? (
          <ButtonLink to={`/quiz/${l.module.id}`}>
            {t('lesson.toQuiz')} <ArrowRight className="size-5" aria-hidden />
          </ButtonLink>
        ) : (
          <Button onClick={() => complete.mutate()} loading={complete.isPending} className="py-3.5 text-lg">
            <CheckCircle2 className="size-5" aria-hidden /> {t('lesson.markDone')}
          </Button>
        )}
      </div>
    </article>
  )
}
