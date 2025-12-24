function formatDate(dateStr) {
  if (!dateStr) return 'Present'
  const date = new Date(dateStr)
  return date.toLocaleDateString('en-US', { month: 'short', year: 'numeric' })
}

export function ExperienceCard({ experience }) {
  return (
    <article className="experience-card">
      <header>
        <h3>{experience.title}</h3>
        <p className="company">{experience.company}</p>
        <p className="dates">
          {formatDate(experience.startDate)} — {formatDate(experience.endDate)}
          {experience.isCurrent && <span className="current-badge">Current</span>}
        </p>
      </header>

      {experience.summary && <p className="summary">{experience.summary}</p>}

      {experience.accomplishments?.length > 0 && (
        <ul className="accomplishments">
          {experience.accomplishments.map((acc, i) => (
            <li key={i}>{acc.accomplishment || acc}</li>
          ))}
        </ul>
      )}

      {experience.skills?.length > 0 && (
        <div className="skills">
          {experience.skills.map(skill => (
            <span key={skill.id} className="skill-tag">{skill.name}</span>
          ))}
        </div>
      )}
    </article>
  )
}
