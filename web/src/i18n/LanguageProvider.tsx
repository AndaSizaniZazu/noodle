import { useQueryClient } from '@tanstack/react-query'
import { createContext, useCallback, useContext, useEffect, useState, type ReactNode } from 'react'
import { useAuth } from '../auth/AuthProvider'
import { api, setApiLanguage } from '../lib/api'
import { translate, type Key, type Lang } from './strings'

type Ctx = {
  lang: Lang
  setLang: (l: Lang) => void
  t: (key: Key, vars?: Record<string, string | number>) => string
}

const LanguageContext = createContext<Ctx>({ lang: 'en', setLang: () => {}, t: (k) => translate('en', k) })

const STORAGE_KEY = 'noodle.lang'

function initialLang(): Lang {
  try {
    const saved = localStorage.getItem(STORAGE_KEY)
    if (saved === 'en' || saved === 'xh') return saved
  } catch {
    /* storage unavailable */
  }
  return navigator.language?.toLowerCase().startsWith('xh') ? 'xh' : 'en'
}

export function LanguageProvider({ children }: { children: ReactNode }) {
  const qc = useQueryClient()
  const { session } = useAuth()
  const [lang, setLangState] = useState<Lang>(() => {
    const l = initialLang()
    setApiLanguage(l)
    return l
  })

  const apply = useCallback(
    (l: Lang) => {
      setApiLanguage(l)
      setLangState(l)
      document.documentElement.lang = l
      try {
        localStorage.setItem(STORAGE_KEY, l)
      } catch {
        /* storage unavailable */
      }
      // Course text comes from the API in the chosen language, so refetch it.
      qc.invalidateQueries()
    },
    [qc],
  )

  // After sign-in, follow the language saved on the teacher's profile (e.g. chosen on another device).
  useEffect(() => {
    if (!session) return
    api<{ language?: Lang }>('/api/me')
      .then((me) => {
        if (me.language && me.language !== lang) apply(me.language)
      })
      .catch(() => {})
    // Only when the signed-in user changes.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [session?.user.id])

  const setLang = useCallback(
    (l: Lang) => {
      apply(l)
      if (session) api('/api/me/language', { method: 'PUT', body: { language: l } }).catch(() => {})
    },
    [apply, session],
  )

  const t = useCallback((key: Key, vars?: Record<string, string | number>) => translate(lang, key, vars), [lang])

  return <LanguageContext.Provider value={{ lang, setLang, t }}>{children}</LanguageContext.Provider>
}

export const useLang = () => useContext(LanguageContext)
