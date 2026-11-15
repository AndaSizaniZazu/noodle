import { Clock, FileText, Languages, ShieldCheck, Sparkles } from 'lucide-react'
import { Link } from 'react-router-dom'
import { Logo } from '../components/Layout'
import { ButtonLink, Card } from '../components/ui'
import { useLang } from '../i18n/LanguageProvider'
import { LanguageSwitch } from '../i18n/LanguageSwitch'
import type { Key } from '../i18n/strings'

const benefits: { icon: typeof Clock; title: Key; text: Key }[] = [
  { icon: Clock, title: 'welcome.b1.title', text: 'welcome.b1.text' },
  { icon: FileText, title: 'welcome.b2.title', text: 'welcome.b2.text' },
  { icon: ShieldCheck, title: 'welcome.b3.title', text: 'welcome.b3.text' },
]

const modules: Key[] = ['welcome.m1', 'welcome.m2', 'welcome.m3', 'welcome.m4', 'welcome.m5', 'welcome.m6', 'welcome.m7', 'welcome.m8']

export default function Welcome() {
  const { t } = useLang()
  return (
    <div className="min-h-dvh">
      <header className="mx-auto flex h-16 max-w-5xl items-center justify-between gap-2 px-4">
        <Logo />
        <div className="flex items-center gap-2">
          <LanguageSwitch />
          <Link to="/signin" className="hidden min-h-11 items-center rounded-xl px-4 font-bold text-teal-800 hover:bg-teal-50 sm:inline-flex dark:text-teal-300 dark:hover:bg-stone-800">
            {t('common.signIn')}
          </Link>
        </div>
      </header>

      <main className="mx-auto max-w-5xl px-4">
        <section className="animate-fade-up py-10 text-center md:py-20">
          <p className="mb-4 inline-flex items-center gap-2 rounded-full bg-amber-100 px-4 py-1.5 text-sm font-bold text-amber-900 dark:bg-amber-900/40 dark:text-amber-200">
            <Sparkles className="size-4" aria-hidden /> {t('welcome.badge')}
          </p>
          <h1 className="mx-auto max-w-3xl text-4xl leading-tight font-extrabold tracking-tight text-stone-900 md:text-6xl dark:text-white">
            {t('welcome.title1')} <span className="text-teal-700 dark:text-teal-400">{t('welcome.title2')}</span>
          </h1>
          <p className="mx-auto mt-5 max-w-xl text-lg text-stone-600 dark:text-stone-300">{t('welcome.lead')}</p>
          <p className="mt-3 inline-flex items-center gap-2 font-semibold text-teal-800 dark:text-teal-300">
            <Languages className="size-5" aria-hidden /> {t('welcome.languages')}
          </p>
          <div className="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row">
            <ButtonLink to="/signup" className="w-full px-8 py-4 text-lg sm:w-auto">
              {t('welcome.start')}
            </ButtonLink>
            <ButtonLink to="/signin" variant="secondary" className="w-full sm:w-auto">
              {t('welcome.haveAccount')}
            </ButtonLink>
          </div>
        </section>

        <section className="grid gap-4 md:grid-cols-3">
          {benefits.map(({ icon: Icon, title, text }) => (
            <Card key={title}>
              <div className="mb-3 grid size-12 place-items-center rounded-xl bg-teal-100 text-teal-800 dark:bg-teal-900/50 dark:text-teal-300">
                <Icon className="size-6" aria-hidden />
              </div>
              <h2 className="text-lg font-extrabold">{t(title)}</h2>
              <p className="mt-1 text-stone-600 dark:text-stone-300">{t(text)}</p>
            </Card>
          ))}
        </section>

        <section className="py-14">
          <h2 className="mb-6 text-center text-2xl font-extrabold md:text-3xl">{t('welcome.learn')}</h2>
          <ol className="mx-auto max-w-2xl space-y-3">
            {modules.map((m, i) => (
              <li key={m} className="flex items-center gap-4 rounded-2xl bg-white p-4 ring-1 ring-stone-200 dark:bg-stone-900 dark:ring-stone-800">
                <span className="grid size-10 shrink-0 place-items-center rounded-full bg-amber-500 font-extrabold text-stone-900">{i + 1}</span>
                <span className="font-semibold">{t(m)}</span>
              </li>
            ))}
          </ol>
          <div className="mt-8 text-center">
            <ButtonLink to="/signup" variant="accent">
              {t('welcome.create')}
            </ButtonLink>
          </div>
        </section>
      </main>

      <footer className="border-t border-stone-200 py-8 text-center text-sm text-stone-500 dark:border-stone-800">{t('welcome.footer')}</footer>
    </div>
  )
}
