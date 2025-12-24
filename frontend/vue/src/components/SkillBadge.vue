<script setup>
defineProps({
  skill: {
    type: Object,
    required: true,
  },
})
</script>

<template>
  <span class="skill-badge" :class="`skill-badge--${skill.category}`">
    {{ skill.name }}
    <span class="proficiency">{{ '●'.repeat(skill.proficiency) }}</span>
  </span>
</template>

<style scoped>
.skill-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.375rem 0.75rem;
  border-radius: 9999px;
  font-size: 0.8125rem;
  background: var(--bg-tag, #f1f5f9);
}

.skill-badge--language { background: #dbeafe; color: #1e40af; }
.skill-badge--framework { background: #dcfce7; color: #166534; }
.skill-badge--tool { background: #fef3c7; color: #92400e; }
.skill-badge--platform { background: #f3e8ff; color: #7c3aed; }
.skill-badge--methodology { background: #fce7f3; color: #be185d; }

.proficiency {
  font-size: 0.5rem;
  opacity: 0.7;
}
</style>
