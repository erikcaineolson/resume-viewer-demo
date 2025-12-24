import { useState } from 'react'
import { useExperiences } from '../hooks/useExperiences'
import { ExperienceCard } from './ExperienceCard'
import { SkillBadge } from './SkillBadge'

export function ResumeViewer() {
  const {
    profile,
    experiences,
    topSkills,
    isLoading,
    error,
    totalYears,
    downloadPdf,
  } = useExperiences()

  const [downloading, setDownloading] = useState(false)

  const handleDownload = async () => {
    setDownloading(true)
    try {
      await downloadPdf()
    } finally {
      setDownloading(false)
    }
  }

  if (isLoading) {
    return <div className="loading">Loading...</div>
  }

  if (error) {
    return <div className="error">Error: {error}</div>
  }

  const sortedExperiences = [...experiences].sort(
    (a, b) => new Date(b.startDate) - new Date(a.startDate)
  )

  return (
    <div className="resume">
      <header className="resume__header">
        <div>
          <h1>{profile?.name}</h1>
          <p className="title">{profile?.title}</p>
          <p className="meta">{totalYears}+ years of experience</p>
        </div>
        <button
          onClick={handleDownload}
          disabled={downloading}
          className="download-btn"
        >
          {downloading ? 'Generating...' : '📄 Download PDF'}
        </button>
      </header>

      {profile?.summary && (
        <section className="summary-section">
          <h2>Summary</h2>
          <p>{profile.summary}</p>
        </section>
      )}

      <section className="skills-section">
        <h2>Top Skills</h2>
        <div className="skill-cloud">
          {topSkills.map(skill => (
            <SkillBadge key={skill.id} skill={skill} />
          ))}
        </div>
      </section>

      <section className="experiences-section">
        <h2>Experience</h2>
        {sortedExperiences.map(exp => (
          <ExperienceCard key={exp.id} experience={exp} />
        ))}
      </section>
    </div>
  )
}
