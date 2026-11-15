import { lazy, Suspense } from 'react'
import { Navigate, Outlet, Route, Routes } from 'react-router-dom'
import { useAuth } from './auth/AuthProvider'
import { Layout } from './components/Layout'
import { Spinner } from './components/ui'
import AuthPage from './pages/AuthPage'
import ResetPassword from './pages/ResetPassword'
import Welcome from './pages/Welcome'

// Signed-in pages load on demand to keep the first download small on mobile data.
const Dashboard = lazy(() => import('./pages/Dashboard'))
const Course = lazy(() => import('./pages/Course'))
const CourseIndex = lazy(() => import('./pages/Course').then((m) => ({ default: m.CourseIndex })))
const Lesson = lazy(() => import('./pages/Lesson'))
const Quiz = lazy(() => import('./pages/Quiz'))
const Playground = lazy(() => import('./pages/Playground'))
const Profile = lazy(() => import('./pages/Profile'))

function RequireAuth() {
  const { session, loading } = useAuth()
  if (loading) return <Spinner />
  return session ? (
    <Suspense fallback={<Spinner />}>
      <Outlet />
    </Suspense>
  ) : (
    <Navigate to="/signin" replace />
  )
}

function Home() {
  const { session, loading } = useAuth()
  if (loading) return <Spinner />
  return session ? <Navigate to="/home" replace /> : <Welcome />
}

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/signin" element={<AuthPage mode="signin" />} />
      <Route path="/signup" element={<AuthPage mode="signup" />} />
      <Route path="/forgot" element={<AuthPage mode="forgot" />} />
      <Route path="/reset-password" element={<ResetPassword />} />
      <Route element={<RequireAuth />}>
        <Route element={<Layout />}>
          <Route path="/home" element={<Dashboard />} />
          <Route path="/course" element={<CourseIndex />} />
          <Route path="/course/:slug" element={<Course />} />
          <Route path="/lessons/:lessonId" element={<Lesson />} />
          <Route path="/quiz/:moduleId" element={<Quiz />} />
          <Route path="/playground" element={<Playground />} />
          <Route path="/profile" element={<Profile />} />
        </Route>
      </Route>
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
