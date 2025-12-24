export function SkillBadge({ skill }) {
  return (
    <span className={`skill-badge skill-badge--${skill.category}`}>
      {skill.name}
      <span className="proficiency">{'●'.repeat(skill.proficiency)}</span>
    </span>
  )
}
