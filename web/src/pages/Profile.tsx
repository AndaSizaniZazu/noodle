import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { LogOut } from 'lucide-react'
import { useState, type FormEvent } from 'react'
import { useNavigate } from 'react-router-dom'
import { Button, Card, ErrorBox, Field, Spinner, inputClass, useToast } from '../components/ui'
import { useLang } from '../i18n/LanguageProvider'
import { LanguageSwitch } from '../i18n/LanguageSwitch'
import { api } from '../lib/api'
import { supabase } from '../lib/supabase'
import type { Me } from '../lib/types'

export default function Profile() {
  const me = useQuery({ queryKey: ['me'], queryFn: () => api<Me>('/api/me') })
  if (me.isPending) return <Spinner />
  if (me.isError) return <ErrorBox message={me.error.message} onRetry={() => me.refetch()} />
  return <ProfileForm me={me.data} />
}

function ProfileForm({ me }: { me: Me }) {
  const toast = useToast()
  const { t } = useLang()
  const qc = useQueryClient()
  const navigate = useNavigate()
  const districts = useQuery({ queryKey: ['districts'], queryFn: () => api<string[]>('/api/districts'), staleTime: Infinity })
  const [form, setForm] = useState({ fullName: me.fullName, school: me.school, district: me.district })

  const save = useMutation({
    mutationFn: () => api<void>('/api/me', { method: 'PUT', body: form }),
    onSuccess: () => {
      toast(t('profile.saved'), 'success')
      qc.invalidateQueries({ queryKey: ['me'] })
    },
    onError: (e) => toast(e.message),
  })

  async function signOut() {
    await supabase.auth.signOut()
    qc.clear()
    navigate('/')
  }

  return (
    <div className="animate-fade-up mx-auto max-w-xl space-y-6">
      <h1 className="text-3xl font-extrabold">{t('profile.title')}</h1>

      <Card>
        <h2 className="font-extrabold">{t('profile.language')}</h2>
        <p className="mb-3 text-stone-600 dark:text-stone-300">{t('profile.languageHint')}</p>
        <LanguageSwitch />
      </Card>

      <Card>
        <form
          className="space-y-4"
          onSubmit={(e: FormEvent) => {
            e.preventDefault()
            save.mutate()
          }}
        >
          <div>
            <p className="font-bold">{t('profile.email')}</p>
            <p className="text-stone-600 dark:text-stone-300">{me.email}</p>
          </div>
          <Field id="p-name" label={t('profile.fullName')} required value={form.fullName} onChange={(e) => setForm({ ...form, fullName: e.target.value })} />
          <Field id="p-school" label={t('auth.school')} value={form.school} onChange={(e) => setForm({ ...form, school: e.target.value })} />
          <div className="space-y-1.5">
            <label htmlFor="p-district" className="block font-bold">
              {t('auth.district')}
            </label>
            <select id="p-district" className={inputClass} value={form.district} onChange={(e) => setForm({ ...form, district: e.target.value })}>
              <option value="">{t('profile.notSet')}</option>
              {districts.data?.map((d) => (
                <option key={d}>{d}</option>
              ))}
            </select>
          </div>
          <Button type="submit" loading={save.isPending}>
            {t('profile.save')}
          </Button>
        </form>
      </Card>
      <Button variant="secondary" onClick={signOut} className="w-full">
        <LogOut className="size-5" aria-hidden /> {t('profile.signOut')}
      </Button>
    </div>
  )
}
