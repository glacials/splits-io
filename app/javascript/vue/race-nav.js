import { ts } from '../time'

export default {
  created: function() {
    this.entrant = this.raceable.entrants.find(entrant => entrant.user.name === gon.user.name)
  },
  data: () => ({
    entrant: null,
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
        this.entrant = await this.updateEntrant({finished_at: new Date(ts.now())})
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
        this.entrant = await this.updateEntrant({forfeited_at: new Date(ts.now())})
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
        this.entrant = await this.updateEntrant({}, 'PUT')
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
        await this.updateEntrant({}, 'DELETE')
        this.entrant = null
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
        this.entrant = await this.updateEntrant({readied_at: new Date(ts.now())})
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
        this.entrant = await this.updateEntrant({finished_at: null})
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
        this.entrant = await this.updateEntrant({forfeited_at: null})
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
        this.entrant = await this.updateEntrant({readied_at: null})
      } catch(error) {
        this.errors.unready = `Error: ${error}`
      } finally {
        this.loading.unready = false
      }
    },
    updateEntrant: async function(params, method = 'PATCH') {
      const response = await fetch(`/api/v4/${this.raceable.type}s/${this.raceable.id}/entrant`, {
        method: method,
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('splitsio_access_token')}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({entrant: params}),
      })

      if (!response.ok) {
        throw (await response.json()).error || response.statusText
      }

      if (response.status === 204 || response.status === 205) {
        // No body to parse
        return
      }

      return (await response.json()).entrant
    },
  },
  name: 'race-nav',
  props: ['raceable'],
}
