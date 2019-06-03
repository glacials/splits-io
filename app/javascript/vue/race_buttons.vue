<template>
  <div id="race-buttons" v-if="!finalized">
    <div class="btn-group" v-if="!joined && !started">
      <button class="btn btn-outline-light" v-tippy :title="errors.join" :disabled="loading.join" @click="join">
        <spinner v-if="loading.join" />
        <i v-else-if="errors.join" class="fas fa-exclamation-triangle" />
        <i v-else class="fas fa-sign-in-alt" />
        Join race
      </button>
    </div>
    <div class="btn-group mr-2" v-if="joined && !started">
      <button class="btn btn-outline-light" disabled>
        <i class="fas fa-check" /> Joined
      </button>
      <button class="btn btn-outline-light" v-tippy :title="errors.leave || 'Leave race'" :disabled="loading.leave" @join="leave">
        <spinner v-if="loading.leave" />
        <i v-else-if="errors.leave" class="fas fa-exclamation-triangle" />
        <i v-else class="fas fa-times" />
      </button>
    </div>

    <div class="btn-group mr-2" v-if="joined && !started && !readied">
      <button class="btn btn-outline-light glow" :disabled="loading.ready" @click="ready">
        <spinner v-if="loading.ready" />
        <i v-else-if="errors.ready" class="fas fa-exclamation-triangle" />
        <i v-else class="fas fa-user-check" />
        Set ready
      </button>
    </div>
    <div class="btn-group mr-2" v-if="joined && !started && readied">
      <button class="btn btn-outline-light" disabled>
        <i class="fas fa-check" /> Ready
      </button>
      <button class="btn btn-outline-light tip" title="Set not ready" :disabled="loading.unready" @click="unready">
        <spinner v-if="loading.unready" />
        <i v-else-if="errors.unready" class="fas fa-exclamation-triangle" />
        <i v-else class="fas fa-times" />
      </button>
    </div>

    <div class="btn-group mr-2" v-if="joined && started && !finished && !forfeited">
      <button class="btn btn-outline-light" v-tippy :title="errors.forfeit" :disabled="loading.forfeit || loading.finish" @click="forfeit">
        <spinner v-if="loading.forfeit" />
        <i v-else-if="errors.forfeit" class="fas fa-exclamation-triangle" />
        <i v-else class="fas fa-heart-broken" />
        Forfeit
      </button>
      <button class="btn btn-outline-light" v-tippy :title="errors.finish" :disabled="loading.forfeit || loading.finish" @click="finish">
        <spinner v-if="loading.finish" />
        <i v-else-if="errors.finish" class="fas fa-exclamation-triangle" />
        <i v-else class="fas fa-flag-checkered" />
        Finish
      </button>
    </div>

    <div class="btn-group mr-2" v-if="joined && started && finished">
      <button class="btn btn-outline-light" disabled>
        <i class="fas fa-check" /> Finished
      </button>
      <button class="btn btn-outline-light tip" v-tippy title="Undo finish" :disabled="loading.unfinish" @click="unfinish">
        <spinner v-if="loading.unfinish" />
        <i v-else-if="errors.unfinish" class="fas fa-exclamation-triangle" />
        <i v-else class="fas fa-times" />
      </button>
    </div>

    <div class="btn-group mr-2" v-if="joined && started && forfeited">
      <button class="btn btn-outline-light" disabled>
        <i class="fas fa-times-circle" /> Forfeited
      </button>
      <button class="btn btn-outline-light tip" v-tippy title="Undo forfeit" :disabled="loading.unforfeit" @click="unforfeit">
        <spinner v-if="loading.unforfeit" />
        <i v-else-if="errors.unforfeit" class="fas fa-exclamation-triangle" />
        <i v-else class="fas fa-times" />
      </button>
    </div>
  </div>
</template>

<script>
import spinner from './spinner.vue'
import ts from 'timesync'

export default {
  components: {
    spinner
  },
  data: () => ({
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

    finished: false,
    finalized: false,
    forfeited: false,
    joined: false,
    started: false,
    readied: false,
  }),
  methods: {
    finish: async function() {
      this.errors.finish = false
      this.loading.finish = true
      try {
        const response = await fetch(`/api/v4/${this.raceType}/${this.raceId}/entrant`, {
          method: 'PATCH',
          body: JSON.stringify({
            finished_at: ts.now(),
          }),
        })

        if (!response.ok) {
          throw response.statusText
        }

        this.finished = true
      } catch(error) {
        this.errors.finish = error
      } finally {
        this.loading.finish = false
      }
    },
    forfeit: async function() {
      this.errors.forfeit = false
      this.loading.forfeit = true
      try {
        const response = await fetch(`/api/v4/${this.raceType}/${this.raceId}/entrant`, {
          method: 'PATCH',
          body: JSON.stringify({
            forfeited_at: ts.now(),
          }),
        })

        if (!response.ok) {
          throw response.statusText
        }

        this.forfeited = true
      } catch(error) {
        this.errors.forfeit = error
      } finally {
        this.loading.forfeit = false
      }
    },
    join: async function() {
      this.errors.join = false
      this.loading.join = true
      try {
        const response = await fetch(`/api/v4/${this.raceType}/${this.raceId}/entrants`, {
          method: 'POST',
        })

        if (!response.ok) {
          throw response.statusText
        }

        this.joined = true
      } catch(error) {
        this.errors.join = error
      } finally {
        this.loading.join = false
      }
    },
    leave: async function() {
      this.errors.leave = false
      this.loading.leave = true
      try {
        const response = await fetch(`/api/v4/${this.raceType}/${this.raceId}/entrant`, {
          method: 'DELETE',
        })

        if (!response.ok) {
          throw response.statusText
        }

        this.joined = false
        this.readied = false
      } catch(error) {
        this.errors.leave = error
      } finally {
        this.loading.leave = false
      }
    },
    ready: async function() {
      this.errors.ready = false
      this.loading.ready = true
      try {
        const response = await fetch(`/api/v4/${this.raceType}/${this.raceId}/entrant`, {
          method: 'PATCH',
          body: JSON.stringify({
            readied_at: ts.now(),
          }),
        })

        if (!response.ok) {
          throw response.statusText
        }

        this.readied = true
      } catch(error) {
        this.errors.ready = error
      } finally {
        this.loading.ready = false
      }
    },
    unfinish: async function() {
      this.errors.unfinish = false
      this.loading.unfinish = true
      try {
        const response = await fetch(`/api/v4/${this.raceType}/${this.raceId}/entrant`, {
          method: 'PATCH',
          body: JSON.stringify({
            finished_at: null,
          }),
        })

        if (!response.ok) {
          throw response.statusText
        }

        this.finished = false
      } catch(error) {
        this.errors.unfinish = error
      } finally {
        this.loading.unfinish = false
      }
    },
    unforfeit: async function() {
      this.errors.unforfeit = false
      this.loading.unforfeit = true
      try {
        const response = await fetch(`/api/v4/${this.raceType}/${this.raceId}/entrant`, {
          method: 'PATCH',
          body: JSON.stringify({
            forfeited_at: null,
          }),
        })

        if (!response.ok) {
          throw response.statusText
        }

        this.forfeited = false
      } catch(error) {
        this.errors.unforfeit = error
      } finally {
        this.loading.unforfeit = false
      }
    },
    unready: async function() {
      this.errors.unready = false
      this.loading.unready = true
      try {
        const response = await fetch(`/api/v4/${this.raceType}/${this.raceId}/entrant`, {
          method: 'PATCH',
          body: JSON.stringify({
            readied_at: null,
          }),
        })

        if (!response.ok) {
          throw response.statusText
        }

        this.readied = false
      } catch(error) {
        this.errors.unready = error
      } finally {
        this.loading.unready = false
      }
    },
  },
  name: 'racebuttons',
  props: ['raceId'],
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
