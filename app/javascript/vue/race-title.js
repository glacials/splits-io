import raceNav from './race-nav.js'

export default {
  components: {
    raceNav,
  },
  computed: {
    title: function() {
      if (this.race === null) {
        return ''
      }
      if (this.race.game === null && this.race.category === null && this.race.notes === null) {
        return 'Untitled race'
      }
      return `${(this.race.game || {}).name} ${(this.race.category || {}).name} ${(this.race.notes || '').split('\n')[0]}`
    },
  },
  created: function() {
    this.notes = this.race.notes
  },
  data: () => ({
    notes: '',
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
            notes: this.notes,
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
  name: 'race-title',
  props: ['race'],
}
