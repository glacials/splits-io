import { ts } from '../time'

export default {
  created: function() {
    this.currentUser = gon.user
    if (this.currentUser === null) {
      return
    }

    this.entry = this.raceable.entries.find(entry => entry.user.id === this.currentUser.id)
  },
  data: () => ({
    currentUser: null,
    entry: null,
    errors: {},
    loading: {
      finish: false,
      forfeit: false,
      join: false,
      leave: false,
      ready: false,
      unfinish: false,
      unforfeit: false,
      unready: false,
    },
  }),
  methods: {
    finish: async function() {
      this.errors.finish = false
      this.loading.finish = true
      try {
        this.entry.finished_at = new Date(ts.now())
        this.updateEntry({finished_at: new Date(ts.now())})
      } catch(error) {
        this.errors.finish = `Error: ${error}`
      } finally {
        this.loading.finish = false
      }
    },
    forfeit: async function() {
      this.errors.forfeit = false
      this.loading.forfeit = true
      try {
        this.entry.forfeited_at = new Date(ts.now())
        this.updateEntry({forfeited_at: new Date(ts.now())})
      } catch(error) {
        this.errors.forfeit = `Error: ${error}`
      } finally {
        this.loading.forfeit = false
      }
    },
    join: async function() {
      this.errors.join = false
      this.loading.join = true
      try {
        this.entry = {}
        this.updateEntry({}, 'PUT')
      } catch(error) {
        this.errors.join = `Error: ${error}`
      } finally {
        this.loading.join = false
      }
    },
    leave: async function() {
      this.errors.leave = false
      this.loading.leave = true
      try {
        this.entry = null
        this.updateEntry({}, 'DELETE')
        this.entry = null
      } catch(error) {
        this.errors.leave = `Error: ${error}`
      } finally {
        this.loading.leave = false
      }
    },
    ready: async function() {
      this.errors.ready = false
      this.loading.ready = true
      try {
        this.entry.readied_at = new Date(ts.now())
        this.updateEntry({readied_at: new Date(ts.now())})
      } catch(error) {
        this.errors.ready = `Error: ${error}`
      } finally {
        this.loading.ready = false
      }
    },
    unfinish: async function() {
      this.errors.unfinish = false
      this.loading.unfinish = true
      try {
        this.entry.finished_at = null
        this.updateEntry({finished_at: null})
      } catch(error) {
        this.errors.unfinish = `Error: ${error}`
      } finally {
        this.loading.unfinish = false
      }
    },
    unforfeit: async function() {
      this.errors.unforfeit = false
      this.loading.unforfeit = true
      try {
        this.entry.forfeited_at = null
        this.updateEntry({forfeited_at: null})
      } catch(error) {
        this.errors.unforfeit = `Error: ${error}`
      } finally {
        this.loading.unforfeit = false
      }
    },
    unready: async function() {
      this.errors.unready = false
      this.loading.unready = true
      try {
        this.entry.readied_at = null
        this.updateEntry({readied_at: null})
      } catch(error) {
        this.errors.unready = `Error: ${error}`
      } finally {
        this.loading.unready = false
      }
    },
    updateEntry: async function(params, method = 'PATCH') {
      const syncEntry = async () => {
        const response = await fetch(`/api/v4/${this.raceable.type}s/${this.raceable.id}/entry`, {
          method: method,
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('splitsio_access_token')}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            entry: params,
            join_token: (new URLSearchParams(window.location.search)).get('join_token')
          }),
        })

        if (!response.ok) {
          throw (await response.json()).error || response.statusText
        }

        if (response.status === 204 || response.status === 205) {
          // No body to parse
          return
        }

        this.entry = (await response.json()).entry
      }

      // Protect against disconnections ruining times -- save the request for later if we're offline
      if (navigator.onLine) {
        syncEntry()
      } else {
        window.addEventListener('online', syncEntry)
      }
    },
  },
  name: 'race-nav',
  props: ['raceable'],
}
