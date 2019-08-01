import { getAccessToken } from '../token'

export default {
  data: () => ({
    body: '',
    error: null,
    loading: false,
  }),
  methods: {
    chat: async function() {
      this.error = false
      this.loading = true

      const headers = new Headers()
      headers.append('Content-Type', 'application/json')
      const accessToken = getAccessToken()
      if (accessToken) {
        headers.append('Authorization', `Bearer ${accessToken}`)
      }

      try {
        const response = fetch(`/api/v4/races/${this.race.id}/chat`, {
          method: 'POST',
          headers: headers,
          body: JSON.stringify({
            body: this.body,
          })
        })

        this.body = ''

        if (!(await response).ok) {
          throw (await response.json()).error || response.statusText
        }

      } catch(error) {
        this.error = error
      } finally {
        this.loading = false
        document.getElementById('input-chat-text').focus()
      }
    },
  },
  name: 'race-chat',
  props: ['race'],
}
