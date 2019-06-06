<template>
  <button class="btn btn-outline-light" v-tippy :title="error" :disabled="loading" @click="create">
    <spinner v-if="loading" />
    <i v-else-if="error" class="fas fa-exclamation-triangle text-danger" />
    <i v-else class="fas fa-flag-checkered" />
    Create race
  </button>
</template>

<script>
import spinner from './spinner.vue'

export default {
  components: {
    spinner,
  },
  data: () => ({
    error: null,
    loading: false,
    notes: '',
    visibility: 'public',
  }),
  methods: {
    create: async function() {
      this.error = false
      this.loading = true
      try {
        const response = await fetch(`/api/v4/${this.raceType}s`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('splitsio_access_token')}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            category_id: document.getElementById('category-select').value,
            game_id: this.gameId,
            notes: this.notes,
            visibility: this.visibility,
          }),
        })

        if (!response.ok) {
          throw (await response.json()).error || response.statusText
        }

        Turbolinks.visit(`/${this.raceType}s/${(await response.json())[this.raceType]['id']}`)
      } catch(error) {
        // Since a success makes the page navigate away, don't unset loading in the success case
        this.loading = false
        this.error = `Error: ${error}`
      }
    },
  },
  name: 'racecreate',
  props: ['race-type', 'game-id'],
}
</script>
