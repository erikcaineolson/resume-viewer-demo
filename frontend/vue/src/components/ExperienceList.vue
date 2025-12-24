<script setup>
import { computed, onMounted, ref } from 'vue'
import { useExperienceStore } from '@/stores/experience'
import ExperienceCard from './ExperienceCard.vue'
import SkillBadge from './SkillBadge.vue'

const store = useExperienceStore()
const isDownloading = ref(false)

const sortedExperiences = computed(() =>
  [...store.experiences].sort((a, b) =>
    new Date(b.startDate) - new Date(a.startDate)
  )
)

const totalYears = computed(() => {
  const months = store.experiences.reduce(
    (sum, exp) => sum + (exp.durationMonths || 0), 0
  )
  return Math.round(months / 12)
})

async function downloadPdf() {
  isDownloading.value = true
  try {
    const response = await fetch('/api/resume/pdf')
    if (!response.ok) throw new Error('Download failed')

    const blob = await response.blob()
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = 'resume.pdf'
    a.click()
    URL.revokeObjectURL(url)
  } catch (e) {
    console.error('PDF download error:', e)
  } finally {
    isDownloading.value = false
  }
}

onMounted(() => store.fetchExperiences())
</script>

<template>
  <section class="experience-list">
    <header class="experience-list__header">
      <div>
        <h2>Professional Experience</h2>
        <p>{{ totalYears }}+ years across {{ store.experiences.length }} roles</p>
      </div>
      <button
        class="download-btn"
        :disabled="isDownloading"
        @click="downloadPdf"
      >
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
          <polyline points="7 10 12 15 17 10"/>
          <line x1="12" y1="15" x2="12" y2="3"/>
        </svg>
        {{ isDownloading ? 'Generating...' : 'Download PDF' }}
      </button>
    </header>

    <div v-if="store.isLoading" class="loading">Loading...</div>
    <div v-else-if="store.error" class="error">{{ store.error }}</div>

    <template v-else>
      <div class="skill-cloud">
        <SkillBadge v-for="skill in store.topSkills" :key="skill.id" :skill="skill" />
      </div>

      <TransitionGroup name="fade" tag="div" class="experience-list__items">
        <ExperienceCard
          v-for="exp in sortedExperiences"
          :key="exp.id"
          :experience="exp"
        />
      </TransitionGroup>
    </template>
  </section>
</template>

<style scoped>
.experience-list__header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.experience-list__header h2 {
  margin: 0;
}

.experience-list__header p {
  margin: 0.25rem 0 0;
  color: var(--text-secondary, #64748b);
}

.download-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background: #3b82f6;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.875rem;
  transition: background 0.2s;
}

.download-btn:hover:not(:disabled) {
  background: #2563eb;
}

.download-btn:disabled {
  opacity: 0.6;
  cursor: wait;
}

.download-btn svg {
  width: 18px;
  height: 18px;
}

.skill-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-bottom: 1.5rem;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
}

.error {
  color: #dc2626;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s, transform 0.3s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}
</style>
