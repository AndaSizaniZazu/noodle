import { useQuery } from '@tanstack/react-query'
import { Eye, EyeOff, MailCheck } from 'lucide-react'
import { useState, type FormEvent } from 'react'
import { Link, Navigate, useNavigate } from 'react-router-dom'
import { useAuth } from '../auth/AuthProvider'
import { Logo } from '../components/Layout'
import { Button, Card, Field, inputClass } from '../components/ui'
import { useLang } from '../i18n/LanguageProvider'
import { LanguageSwitch } from '../i18n/LanguageSwitch'
import type { Key } from '../i18n/strings'
import { api } from '../lib/api'
import { supabase, supabaseConfigured } from '../lib/supabase'

type Mode = 'signin' | 'signup' | 'forgot'

function friendlyKey(msg: string): Key | null {
  if (/invalid login/i.test(msg)) return 'auth.err.invalid'
  if (/already registered/i.test(msg)) return 'auth.err.exists'
  if (/email not confirmed/i.test(msg)) return 'auth.err.unconfirmed'
  if (/password should be/i.test(msg)) return 'auth.err.short'
  return null
}

export default function AuthPage({ mode: initial }: { mode: Mode }) {
  const { session } = useAuth()
  const { t, lang } = useLang()
  const navigate = useNavigate()
  const [mode, setMode] = useState<Mode>(initial)
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [fullName, setFullName] = useState('')
  const [school, setSchool] = useState('')
  const [district, setDistrict] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [sentTo, setSentTo] = useState<string | null>(null)

  const districts = useQuery({
    queryKey: ['districts'],
    queryFn: () => api<string[]>('/api/districts'),
    enabled: mode === 'signup',
    staleTime: Infinity,
  })

  if (session) return <Navigate to="/home" replace />

  const switchTo = (m: Mode) => {
    setMode(m)
    setError(null)
    navigate(m === 'signup' ? '/signup' : m === 'signin' ? '/signin' : '/forgot', { replace: true })
  }

  async function submit(e: FormEvent) {
    e.preventDefault()
    setError(null)
    setBusy(true)
    try {
      if (mode === 'signin') {
        const { error } = await supabase.auth.signInWithPassword({ email, password })
        if (error) throw error
        navigate('/home')
      } else if (mode === 'signup') {
        const { data, error } = await supabase.auth.signUp({
          email,
          password,
          options: {
            data: { full_name: fullName.trim(), school: school.trim(), district, language: lang },
            emailRedirectTo: `${window.location.origin}${import.meta.env.BASE_URL}home`,
          },
        })
        if (error) throw error
        if (data.session) navigate('/home')
        else setSentTo(email)
      } else {
        const { error } = await supabase.auth.resetPasswordForEmail(email, {
          redirectTo: `${window.location.origin}${import.meta.env.BASE_URL}reset-password`,
        })
        if (error) throw error
        setSentTo(email)
      }
    } catch (err) {
      const msg = err instanceof Error ? err.message : ''
      const key = friendlyKey(msg)
      setError(key ? t(key) : msg || t('err.server'))
    } finally {
      setBusy(false)
    }
  }

  const title = t(mode === 'signin' ? 'auth.signinTitle' : mode === 'signup' ? 'auth.signupTitle' : 'auth.forgotTitle')
  const lead = t(mode === 'signin' ? 'auth.signinLead' : mode === 'signup' ? 'auth.signupLead' : 'auth.forgotLead')

  return (
    <div className="flex min-h-dvh flex-col items-center px-4 py-6">
      <div className="mb-6 flex w-full max-w-md items-center justify-between gap-2">
        <Link to="/" aria-label="Noodle">
          <Logo />
        </Link>
        <LanguageSwitch />
      </div>
      <Card className="animate-fade-up w-full max-w-md">
        {sentTo ? (
          <div className="py-4 text-center">
            <MailCheck className="mx-auto mb-4 size-14 text-teal-600" aria-hidden />
            <h1 className="text-2xl font-extrabold">{t('auth.checkEmail')}</h1>
            <p className="mt-2 text-stone-600 dark:text-stone-300">
              {t('auth.sentTo', { email: sentTo })} {t(mode === 'signup' ? 'auth.confirmThenSignIn' : 'auth.clickToReset')}
            </p>
            <Button
              variant="secondary"
              className="mt-6"
              onClick={() => {
                setSentTo(null)
                switchTo('signin')
              }}
            >
              {t('auth.backToSignIn')}
            </Button>
          </div>
        ) : (
          <>
            <h1 className="mb-1 text-2xl font-extrabold">{title}</h1>
            <p className="mb-6 text-stone-600 dark:text-stone-300">{lead}</p>

            {!supabaseConfigured && <p className="mb-4 rounded-xl bg-amber-100 p-3 text-sm text-amber-900">{t('err.setup')}</p>}

            <form onSubmit={submit} className="space-y-4">
              {mode === 'signup' && (
                <>
                  <Field id="name" label={t('auth.fullName')} autoComplete="name" required value={fullName} onChange={(e) => setFullName(e.target.value)} />
                  <Field id="school" label={t('auth.school')} hint={t('common.optional')} autoComplete="organization" value={school} onChange={(e) => setSchool(e.target.value)} />
                  <div className="space-y-1.5">
                    <label htmlFor="district" className="block font-bold">
                      {t('auth.district')}
                    </label>
                    <select id="district" className={inputClass} value={district} onChange={(e) => setDistrict(e.target.value)}>
                      <option value="">{t('auth.chooseDistrict')}</option>
                      {districts.data?.map((d) => (
                        <option key={d}>{d}</option>
                      ))}
                    </select>
                  </div>
                </>
              )}

              <Field id="email" label={t('auth.email')} type="email" autoComplete="email" inputMode="email" required value={email} onChange={(e) => setEmail(e.target.value)} />

              {mode !== 'forgot' && (
                <div className="space-y-1.5">
                  <div className="flex items-center justify-between">
                    <label htmlFor="password" className="font-bold">
                      {t('auth.password')}
                    </label>
                    {mode === 'signin' && (
                      <button type="button" onClick={() => switchTo('forgot')} className="text-sm font-bold text-teal-700 hover:underline dark:text-teal-400">
                        {t('auth.forgot')}
                      </button>
                    )}
                  </div>
                  <div className="relative">
                    <input
                      id="password"
                      type={showPassword ? 'text' : 'password'}
                      autoComplete={mode === 'signup' ? 'new-password' : 'current-password'}
                      required
                      minLength={mode === 'signup' ? 8 : undefined}
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      className={`${inputClass} pr-14`}
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword((s) => !s)}
                      aria-label={t(showPassword ? 'auth.hide' : 'auth.show')}
                      className="absolute inset-y-0 right-0 grid w-12 place-items-center text-stone-500"
                    >
                      {showPassword ? <EyeOff className="size-5" /> : <Eye className="size-5" />}
                    </button>
                  </div>
                  {mode === 'signup' && <p className="text-sm text-stone-500">{t('auth.passwordHint')}</p>}
                </div>
              )}

              {error && (
                <p role="alert" className="rounded-xl bg-red-50 p-3 font-semibold text-red-800 dark:bg-red-950/50 dark:text-red-200">
                  {error}
                </p>
              )}

              <Button type="submit" loading={busy} className="w-full py-3.5 text-lg">
                {t(mode === 'signin' ? 'auth.signinBtn' : mode === 'signup' ? 'auth.signupBtn' : 'auth.sendLink')}
              </Button>
            </form>

            <p className="mt-6 text-center text-stone-600 dark:text-stone-300">
              {mode === 'signup' ? (
                <>
                  {t('auth.haveAccount')}{' '}
                  <button onClick={() => switchTo('signin')} className="font-bold text-teal-700 hover:underline dark:text-teal-400">
                    {t('auth.signinBtn')}
                  </button>
                </>
              ) : (
                <>
                  {t('auth.new')}{' '}
                  <button onClick={() => switchTo('signup')} className="font-bold text-teal-700 hover:underline dark:text-teal-400">
                    {t('auth.createFree')}
                  </button>
                </>
              )}
            </p>
          </>
        )}
      </Card>
    </div>
  )
}
