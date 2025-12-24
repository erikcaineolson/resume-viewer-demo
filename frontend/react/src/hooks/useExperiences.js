import { useState, useEffect, useMemo, useCallback } from 'react'

const API_URL = import.meta.env.VITE_API_URL || '/api'

/**
 * Hook for fetching resume data and downloading PDF.
 */
export function useExperiences() {
  const [experiences, setExperiences] = useState([])
  const [profile, setProfile] = useState(null)
  const [skills, setSkills] = useState([])
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    Promise.all([
      fetch(`${API_URL}/experiences`).then(r => r.json()),
      fetch(`${API_URL}/profile`).then(r => r.json()),
      fetch(`${API_URL}/skills`).then(r => r.json()),
    ])
      .then(([exp, prof, sk]) => {
        setExperiences(exp)
        setProfile(prof)
        setSkills(sk)
      })
      .catch(err => setError(err.message))
      .finally(() => setIsLoading(false))
  }, [])

  const downloadPdf = useCallback(async () => {
    const response = await fetch(`${API_URL}/resume.pdf`)
    const blob = await response.blob()
    const url = URL.createObjectURL(blob)
    Object.assign(document.createElement('a'), {
      href: url,
      download: 'resume.pdf',
    }).click()
    URL.revokeObjectURL(url)
  }, [])

  const totalYears = useMemo(() => {
    const months = experiences.reduce((sum, exp) => {
      const start = new Date(exp.startDate)
      const end = exp.endDate ? new Date(exp.endDate) : new Date()
      return sum + Math.floor((end - start) / (1000 * 60 * 60 * 24 * 30))
    }, 0)
    return Math.round(months / 12)
  }, [experiences])

  const topSkills = useMemo(() => {
    return skills.filter(s => s.proficiency >= 4).slice(0, 10)
  }, [skills])

  return {
    experiences,
    profile,
    skills,
    topSkills,
    isLoading,
    error,
    totalYears,
    downloadPdf,
  }
}
