import { translate, type Lang } from '../i18n/strings'
import { supabase } from './supabase'

const API_URL = ((import.meta.env.VITE_API_URL as string | undefined) ?? 'http://localhost:5155').replace(/\/$/, '')

// Set by LanguageProvider; sent as X-Lang so the API returns lessons and quizzes in that language.
let currentLang: Lang = 'en'
export const setApiLanguage = (l: Lang) => {
  currentLang = l
}

export class ApiError extends Error {
  status: number
  constructor(message: string, status: number) {
    super(message)
    this.status = status
  }
}

type Options = { method?: 'GET' | 'POST' | 'PUT' | 'DELETE'; body?: unknown; signal?: AbortSignal }

/** Calls the .NET API with the teacher's Supabase access token and chosen language attached. */
export async function api<T>(path: string, { method = 'GET', body, signal }: Options = {}): Promise<T> {
  const { data } = await supabase.auth.getSession()
  const token = data.session?.access_token

  let res: Response
  try {
    res = await fetch(`${API_URL}${path}`, {
      method,
      signal,
      headers: {
        'X-Lang': currentLang,
        ...(body !== undefined ? { 'Content-Type': 'application/json' } : {}),
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: body !== undefined ? JSON.stringify(body) : undefined,
    })
  } catch {
    throw new ApiError(translate(currentLang, 'err.network'), 0)
  }

  if (res.status === 204) return undefined as T
  const text = await res.text()
  const json = text ? safeJson(text) : undefined

  if (!res.ok) {
    const apiMessage = (json as { error?: unknown } | undefined)?.error
    const message =
      (typeof apiMessage === 'string' && apiMessage) ||
      translate(currentLang, res.status === 401 ? 'err.session' : 'err.server')
    throw new ApiError(message, res.status)
  }
  return json as T
}

function safeJson(text: string): unknown {
  try {
    return JSON.parse(text)
  } catch {
    return undefined
  }
}
