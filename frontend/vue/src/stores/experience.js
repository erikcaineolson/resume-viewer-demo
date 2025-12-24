import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useExperienceStore = defineStore('experience', () => {
  const experiences = ref([])
  const profile = ref(null)
  const skills = ref([])
  const isLoading = ref(false)
  const error = ref(null)

  const apiUrl = import.meta.env.VITE_API_URL || '/api'

  const topSkills = computed(() =>
    skills.value
      .filter(s => s.proficiency >= 4)
      .slice(0, 10)
  )

  async function fetchExperiences() {
    isLoading.value = true
    error.value = null

    try {
      const [expRes, profileRes, skillsRes] = await Promise.all([
        fetch(`${apiUrl}/experiences`),
        fetch(`${apiUrl}/profile`),
        fetch(`${apiUrl}/skills`),
      ])

      experiences.value = await expRes.json()
      profile.value = await profileRes.json()
      skills.value = await skillsRes.json()
    } catch (e) {
      error.value = e.message
    } finally {
      isLoading.value = false
    }
  }

  return {
    experiences,
    profile,
    skills,
    isLoading,
    error,
    topSkills,
    fetchExperiences,
  }
})
