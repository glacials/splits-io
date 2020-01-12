import { getAccessToken } from '../token'

export default {
  data: () => ({
    error: null,
    loading: false,
  }),
  methods: {
    createPublic: async function() {
      return this.create('public')
    },
    createSecret: async function() {
      return this.create('secret')
    },
    createInviteOnly: async function() {
      return this.create('invite_only')
    },
    create: async function(visibility) {
      try {
        this.loading = true
        this.error = null

        const headers = new Headers()
        headers.append('Content-Type', 'application/json')
        const accessToken = getAccessToken()
        if (accessToken) {
          headers.append('Authorization', `Bearer ${accessToken}`)
        }

        const response = await fetch(`/api/v4/races`, {
          method: 'POST',
          headers: headers,
          body: JSON.stringify({
            game_id: this.gameId,
            category_id: this.categoryId,
            visibility: visibility,
          })
        })

        if (!response.ok) {
          throw (await response.json()).error || response.statusText
        }

        window.location = (await response.json()).race.path
      } catch(error) {
        this.error = `Error: ${error}`
      }
    },
  },
  name: 'race-create',
  props: ['game-id', 'category-id'],
}
