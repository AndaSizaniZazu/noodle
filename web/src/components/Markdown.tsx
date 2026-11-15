import { Check, Copy } from 'lucide-react'
import { useRef, useState, type ReactNode } from 'react'
import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import { useLang } from '../i18n/LanguageProvider'
import { cx } from './ui'

/** Copies text to the clipboard and shows a short "Copied" state. */
export function CopyButton({ getText, label }: { getText: () => string; label?: string }) {
  const { t } = useLang()
  const [copied, setCopied] = useState(false)
  return (
    <button
      type="button"
      onClick={async () => {
        await navigator.clipboard.writeText(getText())
        setCopied(true)
        setTimeout(() => setCopied(false), 1800)
      }}
      className="inline-flex min-h-9 items-center gap-1.5 rounded-lg bg-white/80 px-3 text-sm font-bold text-teal-800 ring-1 ring-teal-200 hover:bg-white dark:bg-stone-900 dark:text-teal-300 dark:ring-teal-800"
    >
      {copied ? <Check className="size-4" aria-hidden /> : <Copy className="size-4" aria-hidden />}
      {copied ? t('common.copied') : (label ?? t('common.copy'))}
    </button>
  )
}

/** Example prompts in lessons are written as blockquotes: show them as a card with a Copy button. */
function PromptQuote({ children }: { children?: ReactNode }) {
  const ref = useRef<HTMLDivElement>(null)
  const { t } = useLang()
  return (
    // Example prompts stay in English (teachers type prompts to the AI in English), so mark them lang="en".
    <div lang="en" className="not-prose my-5 rounded-2xl bg-teal-50 p-4 ring-1 ring-teal-200 dark:bg-teal-950/40 dark:ring-teal-900">
      <div className="mb-2 flex items-center justify-between gap-2">
        <span className="text-xs font-extrabold tracking-wide text-teal-800 uppercase dark:text-teal-300">{t('lesson.examplePrompt')}</span>
        <CopyButton getText={() => ref.current?.innerText.trim() ?? ''} />
      </div>
      <div ref={ref} className="space-y-2 leading-relaxed [&_p]:m-0">
        {children}
      </div>
    </div>
  )
}

export function Markdown({ children, className }: { children: string; className?: string }) {
  return (
    <div
      className={cx(
        'lesson-prose prose prose-stone max-w-none dark:prose-invert prose-headings:font-extrabold prose-a:text-teal-700 prose-th:bg-stone-100 prose-th:px-3 prose-td:px-3 dark:prose-th:bg-stone-800',
        className,
      )}
    >
      <ReactMarkdown remarkPlugins={[remarkGfm]} components={{ blockquote: PromptQuote }}>
        {children}
      </ReactMarkdown>
    </div>
  )
}
