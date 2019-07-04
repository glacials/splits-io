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
        const response = fetch(`/api/v4/races/${this.race.id}/chat`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('splitsio_access_token')}`,
            'Content-Type': 'application/json',
          },
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
        // Give Vue some time to un-disable the field, otherwise it won't focus
        document.getElementById('input-chat-text').focus()
      }
    },
  },
  name: 'race-chat',
  props: ['race'],
}
