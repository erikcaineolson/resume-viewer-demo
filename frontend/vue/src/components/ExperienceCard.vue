<script setup>
defineProps({
  experience: {
    type: Object,
    required: true,
  },
})

function formatDate(dateStr) {
  if (!dateStr) return 'Present'
  const date = new Date(dateStr)
  return date.toLocaleDateString('en-US', { month: 'short', year: 'numeric' })
}
</script>

<template>
  <article class="experience-card">
    <header>
      <h3>{{ experience.title }}</h3>
      <p class="company">{{ experience.company }}</p>
      <p class="dates">
        {{ formatDate(experience.startDate) }} — {{ formatDate(experience.endDate) }}
        <span v-if="experience.isCurrent" class="current-badge">Current</span>
      </p>
    </header>

    <p v-if="experience.summary" class="summary">{{ experience.summary }}</p>

    <ul v-if="experience.accomplishments?.length" class="accomplishments">
      <li v-for="(acc, i) in experience.accomplishments" :key="i">
        {{ acc.accomplishment || acc }}
      </li>
    </ul>

    <div v-if="experience.skills?.length" class="skills">
      <span v-for="skill in experience.skills" :key="skill.id" class="skill-tag">
        {{ skill.name }}
      </span>
    </div>
  </article>
</template>

<style scoped>
.experience-card {
  background: var(--bg-card, #ffffff);
  border: 1px solid var(--border-color, #e2e8f0);
  border-radius: 8px;
  padding: 1.5rem;
  margin-bottom: 1rem;
}

.experience-card h3 {
  margin: 0 0 0.25rem;
  font-size: 1.125rem;
}

.company {
  margin: 0;
  color: var(--text-secondary, #64748b);
  font-weight: 500;
}

.dates {
  margin: 0.5rem 0;
  font-size: 0.875rem;
  color: var(--text-muted, #94a3b8);
}

.current-badge {
  background: var(--accent, #3b82f6);
  color: white;
  padding: 0.125rem 0.5rem;
  border-radius: 9999px;
  font-size: 0.75rem;
  margin-left: 0.5rem;
}

.summary {
  margin: 1rem 0 0.5rem;
}

.accomplishments {
  margin: 0.5rem 0;
  padding-left: 1.25rem;
}

.accomplishments li {
  margin-bottom: 0.25rem;
}

.skills {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 1rem;
}

.skill-tag {
  background: var(--bg-tag, #f1f5f9);
  padding: 0.25rem 0.75rem;
  border-radius: 9999px;
  font-size: 0.75rem;
}
</style>
