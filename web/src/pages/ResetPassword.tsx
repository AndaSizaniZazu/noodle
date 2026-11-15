import { useState, type FormEvent } from 'react'
import { useNavigate } from 'react-router-dom'
import { Logo } from '../components/Layout'
import { Button, Card, Field, useToast } from '../components/ui'
import { useLang } from '../i18n/LanguageProvider'
import { LanguageSwitch } from '../i18n/LanguageSwitch'
import { supabase } from '../lib/supabase'

/** Landing page for the password-reset email link (Supabase signs the user in from the link). */
export default function ResetPassword() {
  const navigate = useNavigate()
  const toast = useToast()
  const { t } = useLang()
  const [password, setPassword] = useState('')
  const [busy, setBusy] = useState(false)

  async function submit(e: FormEvent) {
    e.preventDefault()
    setBusy(true)
    const { error } = await supabase.auth.updateUser({ password })
    setBusy(false)
    if (error) return toast(error.message)
    toast(t('auth.passwordChanged'), 'success')
    navigate('/home')
  }

  return (
    <div className="flex min-h-dvh flex-col items-center px-4 py-6">
      <div className="mb-6 flex w-full max-w-md items-center justify-between gap-2">
        <Logo />
        <LanguageSwitch />
      </div>
      <Card className="w-full max-w-md">
        <h1 className="mb-4 text-2xl font-extrabold">{t('auth.newPassword')}</h1>
        <form onSubmit={submit} className="space-y-4">
          <Field
            id="new-password"
            label={t('auth.newPasswordLabel')}
            type="password"
            autoComplete="new-password"
            minLength={8}
            required
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            hint={t('auth.passwordHint')}
          />
          <Button type="submit" loading={busy} className="w-full">
            {t('auth.savePassword')}
          </Button>
        </form>
      </Card>
    </div>
  )
}
