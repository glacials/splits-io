<template>
  <div id="race-buttons" v-if="race.entrants && race.entrants.every(entrant => entrant.finished_at === null && entrant.forfeited_at === null)">
    <div class="btn-group" v-if="!entrant && !race.started_at">
      <button class="btn btn-outline-light" v-tippy :title="errors.join" :disabled="loading.join" @click="join">
        <spinner v-if="loading.join" />
        <i v-else-if="errors.join" class="fas fa-exclamation-triangle text-danger" />
        <i v-else class="fas fa-sign-in-alt" />
        Join race
      </button>
    </div>
    <div class="btn-group mr-2" v-if="entrant && !race.started_at">
      <button class="btn btn-outline-light" disabled>
        <i class="fas fa-check" /> Joined
      </button>
      <button class="btn btn-outline-light" v-tippy :title="errors.leave || 'Leave race'" :disabled="loading.leave" @click="leave">
        <spinner v-if="loading.leave" />
        <i v-else-if="errors.leave" class="fas fa-exclamation-triangle text-danger" />
        <i v-else class="fas fa-times" />
      </button>
    </div>

    <div class="btn-group mr-2" v-if="entrant && !race.started_at && !entrant.readied_at">
      <button class="btn btn-outline-light glow" v-tippy :title="errors.ready" :disabled="loading.ready" @click="ready">
        <spinner v-if="loading.ready" />
        <i v-else-if="errors.ready" class="fas fa-exclamation-triangle text-danger" />
        <i v-else class="fas fa-user-check" />
        Set ready
      </button>
    </div>
    <div class="btn-group mr-2" v-if="entrant && !race.started_at && entrant.readied_at">
      <button class="btn btn-outline-light" disabled>
        <i class="fas fa-check" /> Ready
      </button>
      <button class="btn btn-outline-light" v-tippy :title="errors.unready || 'Set not ready'" :disabled="loading.unready" @click="unready">
        <spinner v-if="loading.unready" />
        <i v-else-if="errors.unready" class="fas fa-exclamation-triangle text-danger" />
        <i v-else class="fas fa-times" />
      </button>
    </div>

    <div class="btn-group mr-2" v-if="entrant && race.started_at && !entrant.finished_at && !entrant.forfeited_at">
      <button class="btn btn-outline-light" v-tippy :title="errors.forfeit" :disabled="loading.forfeit || loading.finish" @click="forfeit">
        <spinner v-if="loading.forfeit" />
        <i v-else-if="errors.forfeit" class="fas fa-exclamation-triangle text-danger" />
        <i v-else class="fas fa-heart-broken" />
        Forfeit
      </button>
      <button class="btn btn-outline-light" v-tippy :title="errors.finish" :disabled="loading.forfeit || loading.finish" @click="finish">
        <spinner v-if="loading.finish" />
        <i v-else-if="errors.finish" class="fas fa-exclamation-triangle text-danger" />
        <i v-else class="fas fa-flag-checkered" />
        Finish
      </button>
    </div>

    <div class="btn-group mr-2" v-if="entrant && race.started_at && entrant.finished_at">
      <button class="btn btn-outline-light" disabled>
        <i class="fas fa-check" /> Finished
      </button>
      <button class="btn btn-outline-light tip" v-tippy title="Undo finish" :disabled="loading.unfinish" @click="unfinish">
        <spinner v-if="loading.unfinish" />
        <i v-else-if="errors.unfinish" class="fas fa-exclamation-triangle text-danger" />
        <i v-else class="fas fa-times" />
      </button>
    </div>

    <div class="btn-group mr-2" v-if="entrant && race.started_at && entrant.forfeited_at">
      <button class="btn btn-outline-light" disabled>
        <i class="fas fa-times-circle" /> Forfeited
      </button>
      <button class="btn btn-outline-light tip" v-tippy title="Undo forfeit" :disabled="loading.unforfeit" @click="unforfeit">
        <spinner v-if="loading.unforfeit" />
        <i v-else-if="errors.unforfeit" class="fas fa-exclamation-triangle text-danger" />
        <i v-else class="fas fa-times" />
      </button>
    </div>
  </div>
</template>

<script>
import spinner from './spinner.vue'
import { ts } from '../time'

export default {
  components: {
    spinner,
  },
  created: async function() {
    const response = await fetch(`/api/v4/${this.raceType}s/${this.raceId}`, {
      method: 'GET',
      headers: {'Authorization': `Bearer ${localStorage.getItem('splitsio_access_token')}`},
    })

    if (!response.ok) {
      throw (await response.json()).error || response.statusText
    }

    const json = await response.json()
    this.entrant = json[this.raceType].entrants.find(entrant => entrant.user.name === gon.user.name)
    this.race = json[this.raceType]
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

    race: {},
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
      const response = await fetch(`/api/v4/${this.raceType}s/${this.raceId}/entrant`, {
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
  name: 'racebuttons',
  props: ['raceId', 'raceType'],
}
</script>
