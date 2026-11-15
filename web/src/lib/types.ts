export type Me = {
  id: string
  email: string | null
  fullName: string
  school: string
  district: string
  role: 'teacher' | 'facilitator' | 'admin'
  language: 'en' | 'xh'
}

export type Summary = {
  totalLessons: number
  completedLessons: number
  totalModules: number
  quizzesPassed: number
  practiceCount: number
  bestPracticeScore: number | null
  averagePracticeScore: number | null
  nextLesson: { id: string; title: string; moduleTitle: string; courseTitle: string } | null
}

export type CourseListItem = {
  id: string
  slug: string
  title: string
  summary: string
  moduleCount: number
  lessonCount: number
  completedLessons: number
  minutes: number
}

export type LessonListItem = { id: string; position: number; title: string; minutes: number; completed: boolean }

export type ModuleOutline = {
  id: string
  position: number
  title: string
  summary: string
  questionCount: number
  bestQuizScore: number | null
  lessons: LessonListItem[]
}

export type CourseOutline = { id: string; slug: string; title: string; summary: string; modules: ModuleOutline[] }

export type LessonDetail = {
  id: string
  title: string
  contentMd: string
  minutes: number
  practiceTask: string | null
  completed: boolean
  translated: boolean
  draftTranslation: boolean
  module: { id: string; title: string; position: number }
  course: { slug: string; title: string }
  previousLessonId: string | null
  nextLessonId: string | null
  isLastInModule: boolean
}

export type Quiz = {
  id: string
  title: string
  position: number
  courseSlug: string | null
  questions: { id: string; question: string; options: string[] }[]
}

export type QuizResult = {
  score: number
  total: number
  passed: boolean
  results: { questionId: string; chosen: number; correctIndex: number; correct: boolean; explanation: string }[]
}

export type CoachFeedback = {
  role: number
  task: number
  context: number
  format: number
  constraints: number
  privacy_concern: boolean
  summary: string
  strengths: string[]
  improvements: string[]
  improved_prompt: string
}

export type PlaygroundResult = { id: string; aiResponse: string; feedback: CoachFeedback; total: number; outOf: number }

export type PlaygroundHistoryItem = {
  id: string
  prompt: string
  aiResponse: string
  feedback: CoachFeedback
  totalScore: number
  createdAt: string
  lessonId: string | null
}

export type Usage = { used: number; limit: number; remaining: number }
