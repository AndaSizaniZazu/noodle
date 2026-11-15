import { BookOpen, Home, Sparkles, UserRound } from 'lucide-react'
import { Suspense } from 'react'
import { NavLink, Outlet } from 'react-router-dom'
import { useLang } from '../i18n/LanguageProvider'
import { LanguageSwitch } from '../i18n/LanguageSwitch'
import type { Key } from '../i18n/strings'
import { cx, Spinner } from './ui'

const nav: { to: string; label: Key; icon: typeof Home }[] = [
  { to: '/home', label: 'nav.home', icon: Home },
  { to: '/course', label: 'nav.course', icon: BookOpen },
  { to: '/playground', label: 'nav.playground', icon: Sparkles },
  { to: '/profile', label: 'nav.profile', icon: UserRound },
]

export function Logo({ className }: { className?: string }) {
  return (
    <span className={cx('inline-flex items-center gap-2 text-xl font-extrabold text-teal-800 dark:text-teal-300', className)}>
      <img src={`${import.meta.env.BASE_URL}favicon.svg`} alt="" className="size-8" />
      Noodle
    </span>
  )
}

/** App shell: top bar on desktop, bottom tab bar on phones. The language switch is always in the top bar. */
export function Layout() {
  const { t } = useLang()
  return (
    <div className="min-h-dvh pb-24 md:pb-10">
      <a href="#main" className="sr-only focus:not-sr-only focus:absolute focus:top-2 focus:left-2 focus:rounded-lg focus:bg-white focus:px-3 focus:py-2">
        {t('nav.skip')}
      </a>
      <header className="sticky top-0 z-30 border-b border-stone-200 bg-stone-50/90 backdrop-blur dark:border-stone-800 dark:bg-stone-950/90">
        <div className="mx-auto flex h-16 max-w-5xl items-center justify-between gap-3 px-4">
          <NavLink to="/home" aria-label="Noodle">
            <Logo />
          </NavLink>
          <nav aria-label="Main" className="hidden gap-1 md:flex">
            {nav.map(({ to, label, icon: Icon }) => (
              <NavLink
                key={to}
                to={to}
                className={({ isActive }) =>
                  cx(
                    'inline-flex min-h-11 items-center gap-2 rounded-xl px-4 font-bold',
                    isActive
                      ? 'bg-teal-100 text-teal-900 dark:bg-teal-900/50 dark:text-teal-200'
                      : 'text-stone-600 hover:bg-stone-100 dark:text-stone-300 dark:hover:bg-stone-800',
                  )
                }
              >
                <Icon className="size-5" aria-hidden />
                {t(label)}
              </NavLink>
            ))}
          </nav>
          <LanguageSwitch />
        </div>
      </header>

      <main id="main" className="mx-auto max-w-5xl px-4 py-6 md:py-10">
        <Suspense fallback={<Spinner label={t('common.loading')} />}>
          <Outlet />
        </Suspense>
      </main>

      <nav
        aria-label="Main"
        className="fixed inset-x-0 bottom-0 z-30 border-t border-stone-200 bg-white pb-[env(safe-area-inset-bottom)] md:hidden dark:border-stone-800 dark:bg-stone-900"
      >
        <div className="grid grid-cols-4">
          {nav.map(({ to, label, icon: Icon }) => (
            <NavLink
              key={to}
              to={to}
              className={({ isActive }) =>
                cx(
                  'flex min-h-16 flex-col items-center justify-center gap-1 text-xs font-bold',
                  isActive ? 'text-teal-700 dark:text-teal-300' : 'text-stone-500 dark:text-stone-400',
                )
              }
            >
              {({ isActive }) => (
                <>
                  <span className={cx('rounded-full px-4 py-1', isActive && 'bg-teal-100 dark:bg-teal-900/60')}>
                    <Icon className="size-5" aria-hidden />
                  </span>
                  {t(label)}
                </>
              )}
            </NavLink>
          ))}
        </div>
      </nav>
    </div>
  )
}
