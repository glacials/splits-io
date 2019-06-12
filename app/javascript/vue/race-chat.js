import {authifyForm} from '../token'

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
      try {
        const response = await fetch(`/api/v4/${this.raceable.type}s/${this.raceable.id}/chat`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('splitsio_access_token')}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            body: this.body,
          })
        })

        if (!response.ok) {
          throw (await response.json()).error || response.statusText
        }

        this.body = ''
      } catch(error) {
        this.error = error
      } finally {
        this.loading = false
        document.getElementById('chat-submit').focus()
      }
    },
  },
  name: 'race-chat',
  props: ['raceable'],
}
