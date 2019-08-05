import { ts } from '../time'
import { getAccessToken } from '../token'

export default {
  created: function() {
    this.currentUser = gon.user
    if (this.currentUser === null) {
      return
    }

    this.entry = this.race.entries.find((entry) => {
      if (!entry.runner || entry.ghost) {
        return false
      }

      return entry.runner.id === this.currentUser.id
    })
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
        await this.updateEntry({finished_at: new Date(ts.now())})
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
        await this.updateEntry({forfeited_at: new Date(ts.now())})
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
        await this.updateEntry({}, 'POST')
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
        await this.updateEntry({}, 'DELETE')
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
        await this.updateEntry({readied_at: new Date(ts.now())})
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
        await this.updateEntry({finished_at: null})
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
        await this.updateEntry({forfeited_at: null})
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
        await this.updateEntry({readied_at: null})
      } catch(error) {
        this.errors.unready = `Error: ${error}`
      } finally {
        this.loading.unready = false
      }
    },
    updateEntry: async function(params, method = 'PATCH') {
      // Protect against disconnections ruining times -- save the request for later if we're offline
      if (!navigator.onLine) {
        await new Promise(function(resolve, reject) {
          window.setInterval(() => {
            if (navigator.onLine) {
              resolve()
            }
          }, 1000)
        })
      }

      let path
      if (method === 'POST') {
        path = `/api/v4/races/${this.race.id}/entries`
      } else {
        path = `/api/v4/races/${this.race.id}/entries/${this.entry.id}`
      }

      const headers = new Headers()
      headers.append('Content-Type', 'application/json')
      const accessToken = getAccessToken()
      if (accessToken) {
        headers.append('Authorization', `Bearer ${accessToken}`)
      }

      const response = await fetch(path, {
        method: method,
        headers: headers,
        body: JSON.stringify({
          entry: params,
          join_token: (new URLSearchParams(window.location.search)).get('join_token')
        }),
      })

      if (!response.ok) {
        throw (await response.json()).error || response.statusText
      }

      this.entry = (await response.json()).entry
    },
  },
  name: 'race-nav',
  props: ['race'],
}
