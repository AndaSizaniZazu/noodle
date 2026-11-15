import { Loader2 } from 'lucide-react'
import {
  createContext,
  useCallback,
  useContext,
  useState,
  type ButtonHTMLAttributes,
  type InputHTMLAttributes,
  type ReactNode,
} from 'react'
import { Link, type LinkProps } from 'react-router-dom'
import { useLang } from '../i18n/LanguageProvider'

const cx = (...c: (string | false | null | undefined)[]) => c.filter(Boolean).join(' ')
export { cx }

type Variant = 'primary' | 'secondary' | 'ghost' | 'accent'
const variants: Record<Variant, string> = {
  primary: 'bg-teal-700 text-white hover:bg-teal-800 shadow-sm dark:bg-teal-600 dark:hover:bg-teal-500',
  accent: 'bg-amber-500 text-stone-900 hover:bg-amber-400 shadow-sm',
  secondary:
    'bg-white text-teal-800 ring-1 ring-stone-300 hover:bg-stone-100 dark:bg-stone-900 dark:text-teal-300 dark:ring-stone-700 dark:hover:bg-stone-800',
  ghost: 'text-teal-800 hover:bg-teal-50 dark:text-teal-300 dark:hover:bg-stone-800',
}
const base =
  'inline-flex min-h-11 items-center justify-center gap-2 rounded-xl px-5 py-2.5 font-bold transition-colors disabled:cursor-not-allowed disabled:opacity-60'

export function Button({
  variant = 'primary',
  loading,
  className,
  children,
  ...rest
}: ButtonHTMLAttributes<HTMLButtonElement> & { variant?: Variant; loading?: boolean }) {
  return (
    <button className={cx(base, variants[variant], className)} disabled={loading || rest.disabled} {...rest}>
      {loading && <Loader2 className="size-5 animate-spin" aria-hidden />}
      {children}
    </button>
  )
}

export function ButtonLink({ variant = 'primary', className, ...rest }: LinkProps & { variant?: Variant }) {
  return <Link className={cx(base, variants[variant], className)} {...rest} />
}

export function Card({ className, children }: { className?: string; children: ReactNode }) {
  return (
    <div
      className={cx(
        'rounded-2xl bg-white p-5 shadow-sm ring-1 ring-stone-200 sm:p-6 dark:bg-stone-900 dark:ring-stone-800',
        className,
      )}
    >
      {children}
    </div>
  )
}

export function Field({
  label,
  hint,
  id,
  ...rest
}: InputHTMLAttributes<HTMLInputElement> & { label: string; hint?: string; id: string }) {
  return (
    <div className="space-y-1.5">
      <label htmlFor={id} className="block font-bold">
        {label}
      </label>
      <input id={id} className={inputClass} {...rest} />
      {hint && <p className="text-sm text-stone-500 dark:text-stone-400">{hint}</p>}
    </div>
  )
}

export const inputClass =
  'block w-full min-h-12 rounded-xl border-0 bg-white px-4 py-3 ring-1 ring-stone-300 placeholder:text-stone-400 focus:ring-2 focus:ring-teal-600 focus:outline-none dark:bg-stone-900 dark:ring-stone-700'

export function Spinner({ label }: { label?: string }) {
  const { t } = useLang()
  return (
    <div role="status" className="flex items-center justify-center gap-3 py-16 text-stone-500">
      <Loader2 className="size-6 animate-spin" aria-hidden />
      <span>{label ?? t('common.loading')}</span>
    </div>
  )
}

export function ErrorBox({ message, onRetry }: { message: string; onRetry?: () => void }) {
  const { t } = useLang()
  return (
    <Card className="border-l-4 border-red-500 text-center">
      <p className="mb-3">{message}</p>
      {onRetry && (
        <Button variant="secondary" onClick={onRetry}>
          {t('common.tryAgain')}
        </Button>
      )}
    </Card>
  )
}

export function ProgressBar({ value, max, label }: { value: number; max: number; label?: string }) {
  const pct = max > 0 ? Math.round((value / max) * 100) : 0
  return (
    <div
      role="progressbar"
      aria-valuenow={pct}
      aria-valuemin={0}
      aria-valuemax={100}
      aria-label={label ?? 'Progress'}
      className="h-2.5 w-full overflow-hidden rounded-full bg-stone-200 dark:bg-stone-800"
    >
      <div className="h-full rounded-full bg-teal-600 transition-all" style={{ width: `${pct}%` }} />
    </div>
  )
}

export function ProgressRing({
  value,
  max,
  size = 120,
  children,
}: {
  value: number
  max: number
  size?: number
  children?: ReactNode
}) {
  const stroke = 10
  const r = (size - stroke) / 2
  const c = 2 * Math.PI * r
  const pct = max > 0 ? value / max : 0
  return (
    <div className="relative inline-grid place-items-center" style={{ width: size, height: size }}>
      <svg width={size} height={size} className="-rotate-90" aria-hidden>
        <circle cx={size / 2} cy={size / 2} r={r} fill="none" strokeWidth={stroke} className="stroke-stone-200 dark:stroke-stone-800" />
        <circle
          cx={size / 2}
          cy={size / 2}
          r={r}
          fill="none"
          strokeWidth={stroke}
          strokeLinecap="round"
          strokeDasharray={c}
          strokeDashoffset={c * (1 - pct)}
          className="stroke-teal-600 transition-all duration-700"
        />
      </svg>
      <div className="absolute inset-0 grid place-items-center text-center">{children}</div>
    </div>
  )
}

/* ---------- Toasts ---------- */

type Toast = { id: number; message: string; kind: 'error' | 'success' }
const ToastContext = createContext<(message: string, kind?: Toast['kind']) => void>(() => {})

export function ToastProvider({ children }: { children: ReactNode }) {
  const [toasts, setToasts] = useState<Toast[]>([])
  const show = useCallback((message: string, kind: Toast['kind'] = 'error') => {
    const id = Date.now() + Math.random()
    setToasts((t) => [...t, { id, message, kind }])
    setTimeout(() => setToasts((t) => t.filter((x) => x.id !== id)), 5000)
  }, [])
  return (
    <ToastContext.Provider value={show}>
      {children}
      <div aria-live="polite" className="fixed inset-x-4 top-4 z-50 mx-auto flex max-w-md flex-col gap-2">
        {toasts.map((t) => (
          <div
            key={t.id}
            className={cx(
              'animate-fade-up rounded-xl px-4 py-3 font-semibold shadow-lg',
              t.kind === 'error' ? 'bg-red-700 text-white' : 'bg-teal-700 text-white',
            )}
          >
            {t.message}
          </div>
        ))}
      </div>
    </ToastContext.Provider>
  )
}

export const useToast = () => useContext(ToastContext)
