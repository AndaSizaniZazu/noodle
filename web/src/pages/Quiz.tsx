import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { ArrowLeft, ArrowRight, CheckCircle2, PartyPopper, RotateCcw, XCircle } from 'lucide-react'
import { useState } from 'react'
import { useParams } from 'react-router-dom'
import { Button, ButtonLink, Card, ErrorBox, Spinner, cx, useToast } from '../components/ui'
import { useLang } from '../i18n/LanguageProvider'
import { api } from '../lib/api'
import type { Quiz as QuizT, QuizResult } from '../lib/types'

export default function Quiz() {
  const { moduleId = '' } = useParams()
  const toast = useToast()
  const { t } = useLang()
  const qc = useQueryClient()
  const quiz = useQuery({ queryKey: ['quiz', moduleId], queryFn: () => api<QuizT>(`/api/modules/${moduleId}/quiz`) })
  const [answers, setAnswers] = useState<(number | null)[]>([])
  const [step, setStep] = useState(0)
  const [result, setResult] = useState<QuizResult | null>(null)

  const submit = useMutation({
    mutationFn: (a: number[]) => api<QuizResult>(`/api/modules/${moduleId}/quiz`, { method: 'POST', body: { answers: a } }),
    onSuccess: (r) => {
      setResult(r)
      qc.invalidateQueries({ queryKey: ['summary'] })
      qc.invalidateQueries({ queryKey: ['course'] })
      qc.invalidateQueries({ queryKey: ['courses'] })
      window.scrollTo({ top: 0 })
    },
    onError: (e) => toast(e.message),
  })

  if (quiz.isPending) return <Spinner label={t('quiz.loading')} />
  if (quiz.isError) return <ErrorBox message={quiz.error.message} onRetry={() => quiz.refetch()} />

  const q = quiz.data
  const total = q.questions.length
  const current = q.questions[step]
  const chosen = answers[step] ?? null
  const choose = (i: number) => setAnswers((a) => Object.assign([...a], { [step]: i }))
  const restart = () => {
    setAnswers([])
    setStep(0)
    setResult(null)
  }

  if (result) {
    return (
      <div className="animate-fade-up mx-auto max-w-2xl space-y-5">
        <Card className="text-center">
          {result.passed ? <PartyPopper className="mx-auto size-14 text-amber-500" aria-hidden /> : <RotateCcw className="mx-auto size-14 text-teal-600" aria-hidden />}
          <p className="mt-3 text-5xl font-extrabold">
            {result.score}/{result.total}
          </p>
          <h1 className="mt-2 text-2xl font-extrabold">{t(result.passed ? 'quiz.wellDone' : 'quiz.goodTry')}</h1>
          <p className="mt-1 text-stone-600 dark:text-stone-300">{t(result.passed ? 'quiz.passedText' : 'quiz.failedText')}</p>
          <div className="mt-5 flex flex-col justify-center gap-3 sm:flex-row">
            <ButtonLink to={q.courseSlug ? `/course/${q.courseSlug}` : '/course'}>{t('quiz.backToCourse')}</ButtonLink>
            {!result.passed && (
              <Button variant="secondary" onClick={restart}>
                {t('common.tryAgain')}
              </Button>
            )}
          </div>
        </Card>

        <h2 className="text-xl font-extrabold">{t('quiz.yourAnswers')}</h2>
        {q.questions.map((question, i) => {
          const r = result.results[i]
          return (
            <Card key={question.id} className={cx('border-l-4', r.correct ? 'border-teal-500' : 'border-amber-500')}>
              <p className="flex items-start gap-2 font-bold">
                {r.correct ? <CheckCircle2 className="mt-0.5 size-5 shrink-0 text-teal-600" aria-hidden /> : <XCircle className="mt-0.5 size-5 shrink-0 text-amber-600" aria-hidden />}
                {question.question}
              </p>
              {!r.correct && (
                <p className="mt-2 text-stone-600 dark:text-stone-300">
                  {t('quiz.yourAnswer')} {question.options[r.chosen]}
                  <br />
                  <strong>
                    {t('quiz.correctAnswer')} {question.options[r.correctIndex]}
                  </strong>
                </p>
              )}
              <p className="mt-2 rounded-xl bg-stone-100 p-3 dark:bg-stone-800">💡 {r.explanation}</p>
            </Card>
          )
        })}
      </div>
    )
  }

  const isLast = step === total - 1
  return (
    <div className="mx-auto max-w-2xl">
      <p className="text-sm font-bold text-stone-500">{t('quiz.moduleQuiz', { n: q.position })}</p>
      <h1 className="text-2xl font-extrabold md:text-3xl">{q.title}</h1>

      <div className="my-5 flex items-center gap-2" aria-hidden>
        {q.questions.map((_, i) => (
          <span key={i} className={cx('h-2.5 flex-1 rounded-full', i < step || answers[i] != null ? 'bg-teal-600' : i === step ? 'bg-teal-300' : 'bg-stone-200 dark:bg-stone-800')} />
        ))}
      </div>

      <Card key={current.id} className="animate-fade-up">
        <p className="text-sm font-bold text-stone-500">{t('quiz.question', { n: step + 1, total })}</p>
        <h2 id="question" className="mt-1 mb-5 text-xl font-extrabold">
          {current.question}
        </h2>
        <div role="radiogroup" aria-labelledby="question" className="space-y-3">
          {current.options.map((opt, i) => (
            <button
              key={i}
              role="radio"
              aria-checked={chosen === i}
              onClick={() => choose(i)}
              className={cx(
                'flex min-h-14 w-full items-center gap-3 rounded-xl p-4 text-left font-semibold ring-2 transition-colors',
                chosen === i ? 'bg-teal-50 ring-teal-600 dark:bg-teal-950/50' : 'bg-white ring-stone-200 hover:ring-teal-300 dark:bg-stone-900 dark:ring-stone-700',
              )}
            >
              <span className={cx('grid size-8 shrink-0 place-items-center rounded-full text-sm font-extrabold', chosen === i ? 'bg-teal-600 text-white' : 'bg-stone-100 dark:bg-stone-800')}>
                {String.fromCharCode(65 + i)}
              </span>
              {opt}
            </button>
          ))}
        </div>
      </Card>

      <div className="mt-6 flex items-center justify-between gap-3">
        <Button variant="ghost" onClick={() => setStep((s) => s - 1)} disabled={step === 0}>
          <ArrowLeft className="size-5" aria-hidden /> {t('common.back')}
        </Button>
        {isLast ? (
          <Button onClick={() => submit.mutate(answers as number[])} disabled={answers.length !== total || answers.some((a) => a == null)} loading={submit.isPending}>
            {t('quiz.check')}
          </Button>
        ) : (
          <Button onClick={() => setStep((s) => s + 1)} disabled={chosen == null}>
            {t('common.next')} <ArrowRight className="size-5" aria-hidden />
          </Button>
        )}
      </div>
    </div>
  )
}
