import raceChat from './race-chat.js'
import raceNav from './race-nav.js'

export default {
  components: {
    raceChat,
    raceNav
  },
  created: async function() {
    this.loading = true
    this.error = false

    const response = await fetch(`/api/v4/${this.raceableType}s/${this.raceableId}`, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('splitsio_access_token')}`,
      },
    })
    if (!response.ok) {
      throw (await response.json()).error || response.statusText
    }

    this.raceable = (await response.json())[this.raceableType]
    this.loading = false
  },
  data: () => ({
    error: false,
    loading: false,
    raceable: null,
  }),
  name: 'race',
  props: ['raceable-type', 'raceable-id'],
}
