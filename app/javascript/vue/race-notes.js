export default {
  created: function() {
    this.body = this.race.notes
  },
  data: () => ({
    body: '',
    editing: false,
    error: null,
    loading: false,
  }),
  methods: {
    cancel: function() {
      this.editing = false
    },
    edit: async function() {
      this.editing = true
    },
    save: async function() {
      this.error = false
      this.loading = true
      this.editing = false
      try {
        const response = fetch(`/api/v4/races/${this.race.id}`, {
          method: 'PATCH',
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('splitsio_access_token')}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            notes: this.body,
          })
        })

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
  name: 'race-notes',
  props: ['race'],
}
