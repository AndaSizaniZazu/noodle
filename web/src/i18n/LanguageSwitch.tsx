import { Languages } from 'lucide-react'
import { cx } from '../components/ui'
import { useLang } from './LanguageProvider'
import type { Lang } from './strings'

/** English / isiXhosa toggle. Big enough to tap easily on a phone. */
export function LanguageSwitch({ className }: { className?: string }) {
  const { lang, setLang, t } = useLang()
  const options: { value: Lang; label: string }[] = [
    { value: 'en', label: 'English' },
    { value: 'xh', label: 'isiXhosa' },
  ]
  return (
    <div role="group" aria-label={t('lang.label')} className={cx('inline-flex items-center gap-1 rounded-xl bg-stone-200/70 p-1 dark:bg-stone-800', className)}>
      <Languages className="ml-1.5 size-4 text-stone-500" aria-hidden />
      {options.map((o) => (
        <button
          key={o.value}
          type="button"
          lang={o.value}
          aria-pressed={lang === o.value}
          onClick={() => setLang(o.value)}
          className={cx(
            'min-h-9 rounded-lg px-3 text-sm font-bold transition-colors',
            lang === o.value ? 'bg-white text-teal-800 shadow-sm dark:bg-stone-900 dark:text-teal-300' : 'text-stone-600 hover:text-stone-900 dark:text-stone-300',
          )}
        >
          {o.label}
        </button>
      ))}
    </div>
  )
}
