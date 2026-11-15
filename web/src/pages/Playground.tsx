import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { AlertTriangle, Bot, ChevronDown, Info, Lightbulb, Lock, RotateCcw, Send, Sparkles, ThumbsUp } from 'lucide-react'
import { useEffect, useRef, useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { CopyButton, Markdown } from '../components/Markdown'
import { Button, Card, ProgressRing, cx, inputClass, useToast } from '../components/ui'
import { useLang } from '../i18n/LanguageProvider'
import type { Key } from '../i18n/strings'
import { api } from '../lib/api'
import type { CoachFeedback, LessonDetail, PlaygroundHistoryItem, PlaygroundResult, Usage } from '../lib/types'

const MAX = 4000

// Building blocks insert English text: AI tools answer best when the prompt is written in English.
const chips = [
  { label: 'Role', text: 'You are an experienced ' },
  { label: 'Task', text: 'Write a ' },
  { label: 'Context', text: 'My class is Grade __, __ learners, home language __. We have ' },
  { label: 'Format', text: 'Use headings and keep it under one page. ' },
  { label: 'Constraints', text: 'No printing needed. Maximum __ minutes. ' },
]

const tips: Key[] = ['pg.tip1', 'pg.tip2', 'pg.tip3', 'pg.tip4', 'pg.tip5']

const criteria: { key: keyof CoachFeedback; label: string; help: Key }[] = [
  { key: 'role', label: 'Role', help: 'pg.c.role' },
  { key: 'task', label: 'Task', help: 'pg.c.task' },
  { key: 'context', label: 'Context', help: 'pg.c.context' },
  { key: 'format', label: 'Format', help: 'pg.c.format' },
  { key: 'constraints', label: 'Constraints', help: 'pg.c.constraints' },
]

const scoreKey = (total: number): Key => (total >= 9 ? 'pg.score.9' : total >= 7 ? 'pg.score.7' : total >= 4 ? 'pg.score.4' : 'pg.score.0')

function Feedback({ f, total, onUse }: { f: CoachFeedback; total: number; onUse: (p: string) => void }) {
  const { t } = useLang()
  return (
    <div className="space-y-5">
      <div className="flex items-center gap-5">
        <ProgressRing value={total} max={10} size={104}>
          <div>
            <div className="text-3xl font-extrabold">{total}</div>
            <div className="text-xs text-stone-500">{t('pg.outOf10')}</div>
          </div>
        </ProgressRing>
        <div>
          <p className="text-xl font-extrabold">{t(scoreKey(total))}</p>
          <p className="mt-1 text-stone-600 dark:text-stone-300">{f.summary}</p>
        </div>
      </div>

      {f.privacy_concern && (
        <p role="alert" className="flex gap-2 rounded-xl bg-red-50 p-3 font-semibold text-red-800 dark:bg-red-950/50 dark:text-red-200">
          <AlertTriangle className="size-5 shrink-0" aria-hidden /> {t('pg.privacy')}
        </p>
      )}

      <ul className="space-y-3">
        {criteria.map(({ key, label, help }) => {
          const v = f[key] as number
          return (
            <li key={key}>
              <div className="flex justify-between gap-2 text-sm">
                <span>
                  <strong>{label}</strong> <span className="text-stone-500">· {t(help)}</span>
                </span>
                <span className="font-bold">{v}/2</span>
              </div>
              <div className="mt-1 grid grid-cols-2 gap-1" aria-hidden>
                {[0, 1].map((i) => (
                  <span key={i} className={cx('h-2.5 rounded-full', i < v ? (v === 2 ? 'bg-teal-600' : 'bg-amber-500') : 'bg-stone-200 dark:bg-stone-800')} />
                ))}
              </div>
            </li>
          )
        })}
      </ul>

      {f.strengths.length > 0 && (
        <div>
          <h3 className="mb-2 flex items-center gap-2 font-extrabold">
            <ThumbsUp className="size-5 text-teal-600" aria-hidden /> {t('pg.wellDone')}
          </h3>
          <ul className="list-disc space-y-1 pl-6">
            {f.strengths.map((s) => (
              <li key={s}>{s}</li>
            ))}
          </ul>
        </div>
      )}
      {f.improvements.length > 0 && (
        <div>
          <h3 className="mb-2 flex items-center gap-2 font-extrabold">
            <Lightbulb className="size-5 text-amber-500" aria-hidden /> {t('pg.better')}
          </h3>
          <ul className="list-disc space-y-1 pl-6">
            {f.improvements.map((s) => (
              <li key={s}>{s}</li>
            ))}
          </ul>
        </div>
      )}

      <div className="rounded-2xl bg-teal-50 p-4 ring-1 ring-teal-200 dark:bg-teal-950/40 dark:ring-teal-900">
        <div className="mb-2 flex flex-wrap items-center justify-between gap-2">
          <h3 className="font-extrabold text-teal-900 dark:text-teal-200">{t('pg.improved')}</h3>
          <div className="flex gap-2">
            <CopyButton getText={() => f.improved_prompt} />
            <button
              type="button"
              onClick={() => onUse(f.improved_prompt)}
              className="inline-flex min-h-9 items-center gap-1.5 rounded-lg bg-teal-700 px-3 text-sm font-bold text-white hover:bg-teal-800"
            >
              <RotateCcw className="size-4" aria-hidden /> {t('pg.tryVersion')}
            </button>
          </div>
        </div>
        <p className="whitespace-pre-wrap">{f.improved_prompt}</p>
      </div>
    </div>
  )
}

export default function Playground() {
  const [params] = useSearchParams()
  const lessonId = params.get('lesson')
  const toast = useToast()
  const { t, lang } = useLang()
  const qc = useQueryClient()
  const textRef = useRef<HTMLTextAreaElement>(null)
  const resultRef = useRef<HTMLDivElement>(null)
  const [prompt, setPrompt] = useState('')
  const [tab, setTab] = useState<'feedback' | 'answer'>('feedback')
  const [tip, setTip] = useState(0)

  const lesson = useQuery({
    queryKey: ['lesson', lessonId],
    queryFn: () => api<LessonDetail>(`/api/courses/lessons/${lessonId}`),
    enabled: Boolean(lessonId),
  })
  const usage = useQuery({ queryKey: ['usage'], queryFn: () => api<Usage>('/api/playground/usage') })
  const history = useQuery({ queryKey: ['history'], queryFn: () => api<PlaygroundHistoryItem[]>('/api/playground/history') })

  const run = useMutation({
    mutationFn: () => api<PlaygroundResult>('/api/playground', { method: 'POST', body: { prompt, lessonId } }),
    onSuccess: () => {
      setTab('feedback')
      qc.invalidateQueries({ queryKey: ['usage'] })
      qc.invalidateQueries({ queryKey: ['history'] })
      qc.invalidateQueries({ queryKey: ['summary'] })
      setTimeout(() => resultRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' }), 50)
    },
    onError: (e) => toast(e.message),
  })

  useEffect(() => {
    if (!run.isPending) return
    const timer = setInterval(() => setTip((i) => (i + 1) % tips.length), 4000)
    return () => clearInterval(timer)
  }, [run.isPending])

  const insert = (text: string) => {
    const el = textRef.current
    const start = el?.selectionStart ?? prompt.length
    const end = el?.selectionEnd ?? prompt.length
    const sep = start > 0 && !/\s$/.test(prompt.slice(0, start)) ? ' ' : ''
    const next = prompt.slice(0, start) + sep + text + prompt.slice(end)
    setPrompt(next.slice(0, MAX))
    requestAnimationFrame(() => {
      el?.focus()
      const pos = start + sep.length + text.length
      el?.setSelectionRange(pos, pos)
    })
  }

  const useImproved = (p: string) => {
    setPrompt(p)
    run.reset()
    window.scrollTo({ top: 0, behavior: 'smooth' })
    textRef.current?.focus()
  }

  const outOfTries = usage.data?.remaining === 0
  const r = run.data

  return (
    <div className="space-y-6">
      <header>
        <h1 className="flex items-center gap-2 text-3xl font-extrabold md:text-4xl">
          <Sparkles className="size-8 text-amber-500" aria-hidden /> {t('pg.title')}
        </h1>
        <p className="mt-1 text-lg text-stone-600 dark:text-stone-300">{t('pg.lead')}</p>
      </header>

      {lesson.data?.practiceTask && (
        <Card className="bg-amber-50 ring-amber-200 dark:bg-amber-950/30 dark:ring-amber-900">
          <p className="text-sm font-bold tracking-wide text-amber-900 uppercase dark:text-amber-200">
            {t('pg.task')} · {lesson.data.title}
          </p>
          <p className="mt-1 text-lg">{lesson.data.practiceTask}</p>
        </Card>
      )}

      <p className="flex items-start gap-2 rounded-xl bg-teal-50 p-3 text-teal-900 dark:bg-teal-950/40 dark:text-teal-100">
        <Lock className="mt-0.5 size-5 shrink-0" aria-hidden />
        <span>
          <strong>{t('pg.safe')}</strong> {t('pg.safeText')}
        </span>
      </p>

      {lang === 'xh' && (
        <p className="flex items-start gap-2 rounded-xl bg-sky-50 p-3 text-sky-900 dark:bg-sky-950/40 dark:text-sky-100">
          <Info className="mt-0.5 size-5 shrink-0" aria-hidden /> {t('pg.promptEnglishTip')}
        </p>
      )}

      <Card>
        <form
          onSubmit={(e) => {
            e.preventDefault()
            run.mutate()
          }}
        >
          <label htmlFor="prompt" className="mb-2 block text-lg font-extrabold">
            {t('pg.yourPrompt')}
          </label>
          <div className="mb-3 flex flex-wrap gap-2" role="group" aria-label={t('pg.blocks')}>
            {chips.map((c) => (
              <button
                key={c.label}
                type="button"
                onClick={() => insert(c.text)}
                className="min-h-10 rounded-full bg-stone-100 px-4 text-sm font-bold text-stone-700 hover:bg-teal-100 hover:text-teal-900 dark:bg-stone-800 dark:text-stone-200 dark:hover:bg-teal-900"
              >
                + {c.label}
              </button>
            ))}
          </div>
          <textarea
            id="prompt"
            ref={textRef}
            value={prompt}
            onChange={(e) => setPrompt(e.target.value.slice(0, MAX))}
            rows={7}
            placeholder={t('pg.placeholder')}
            className={cx(inputClass, 'min-h-44 resize-y leading-relaxed')}
            aria-describedby="prompt-help"
          />
          <div id="prompt-help" className="mt-2 flex flex-wrap items-center justify-between gap-2 text-sm text-stone-500">
            <span>{t('pg.chars', { n: prompt.length, max: MAX })}</span>
            {usage.data && (
              <span className={cx('font-semibold', outOfTries && 'text-amber-700')}>{t('pg.triesLeft', { n: usage.data.remaining, max: usage.data.limit })}</span>
            )}
          </div>
          <Button type="submit" loading={run.isPending} disabled={prompt.trim().length < 10 || outOfTries} className="mt-4 w-full py-3.5 text-lg sm:w-auto">
            {!run.isPending && <Send className="size-5" aria-hidden />}
            {t(run.isPending ? 'pg.working' : 'pg.send')}
          </Button>
        </form>
      </Card>

      {run.isPending && (
        <Card className="text-center">
          <Bot className="mx-auto size-12 animate-bounce text-teal-600" aria-hidden />
          <p className="mt-3 font-bold">{t('pg.waiting')}</p>
          <p className="text-stone-500">{t('pg.wait')}</p>
          <p key={tip} className="animate-fade-up mt-4 rounded-xl bg-amber-50 p-3 text-amber-900 dark:bg-amber-950/40 dark:text-amber-200" aria-live="polite">
            {t(tips[tip])}
          </p>
        </Card>
      )}

      {r && (
        <div ref={resultRef} className="animate-fade-up scroll-mt-20">
          <div role="tablist" className="mb-3 grid grid-cols-2 gap-2 rounded-2xl bg-stone-200 p-1 lg:hidden dark:bg-stone-800">
            {(['feedback', 'answer'] as const).map((k) => (
              <button
                key={k}
                role="tab"
                aria-selected={tab === k}
                onClick={() => setTab(k)}
                className={cx('min-h-11 rounded-xl font-bold', tab === k ? 'bg-white shadow-sm dark:bg-stone-900' : 'text-stone-600 dark:text-stone-300')}
              >
                {t(k === 'feedback' ? 'pg.tabFeedback' : 'pg.tabAnswer')}
              </button>
            ))}
          </div>
          <div className="grid gap-5 lg:grid-cols-2">
            <Card className={cx(tab !== 'feedback' && 'hidden lg:block')}>
              <h2 className="mb-4 hidden text-xl font-extrabold lg:block">{t('pg.tabFeedback')}</h2>
              <Feedback f={r.feedback} total={r.total} onUse={useImproved} />
            </Card>
            <Card className={cx(tab !== 'answer' && 'hidden lg:block')}>
              <div className="mb-4 flex items-center justify-between gap-2">
                <h2 className="text-xl font-extrabold">{t('pg.tabAnswer')}</h2>
                <CopyButton getText={() => r.aiResponse} />
              </div>
              <Markdown>{r.aiResponse}</Markdown>
              <p className="mt-4 rounded-xl bg-stone-100 p-3 text-sm dark:bg-stone-800">{t('pg.checkAnswer')}</p>
            </Card>
          </div>
        </div>
      )}

      {history.data && history.data.length > 0 && (
        <section>
          <h2 className="mb-3 text-xl font-extrabold">{t('pg.history')}</h2>
          <ul className="space-y-3">
            {history.data.map((h) => (
              <li key={h.id}>
                <details className="group rounded-2xl bg-white ring-1 ring-stone-200 dark:bg-stone-900 dark:ring-stone-800">
                  <summary className="flex min-h-14 cursor-pointer list-none items-center gap-3 p-4">
                    <span className={cx('grid size-11 shrink-0 place-items-center rounded-full font-extrabold', h.totalScore >= 7 ? 'bg-teal-100 text-teal-900' : 'bg-amber-100 text-amber-900')}>
                      {h.totalScore}
                    </span>
                    <span className="line-clamp-2 flex-1">{h.prompt}</span>
                    <ChevronDown className="size-5 shrink-0 transition-transform group-open:rotate-180" aria-hidden />
                  </summary>
                  <div className="border-t border-stone-100 p-4 dark:border-stone-800">
                    <p className="mb-4 text-sm text-stone-500">{new Date(h.createdAt).toLocaleString(lang === 'xh' ? 'xh-ZA' : 'en-ZA')}</p>
                    <Feedback f={h.feedback} total={h.totalScore} onUse={useImproved} />
                  </div>
                </details>
              </li>
            ))}
          </ul>
        </section>
      )}
    </div>
  )
}
