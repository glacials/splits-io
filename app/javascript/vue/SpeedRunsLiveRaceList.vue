<template>
  <div class="card">
    <div class="card-header justify-content-between d-flex">
      <span>
        <img src="//cdn.speedrunslive.com/images/srl_305.png" style="height: 1em" alt="SpeedRunsLive logo" />
        <small
          class="fas fa-info-circle"
          content="For your convenience, these are the open races on SpeedRunsLive. Splits.io is not affiliated with SpeedRunsLive."
          v-tippy
        ></small>
      </span>
      <span class="text-danger text-uppercase">
        <small class="fas fa-circle" />
        Live
      </span>
    </div>
    <div class="list-group bg-transparent" v-cloak>
      <span class="spinner-border spinner-border-sm mx-auto m-5" role="status" v-if="loading">
        <span class="sr-only">Loading...</span>
      </span>
      <speed-runs-live-race v-for="(race, i) in races" v-model="races[i]" v-bind:key="race.id" />
    </div>
  </div>
</template>

<script>
import SpeedRunsLiveRace from './SpeedRunsLiveRace.vue'

export default {
  beforeDestroy: function () {
    clearInterval(this.timer)
  },
  components: {
    SpeedRunsLiveRace,
  },
  created: function () {
    this.refreshRaces()
    this.timer = setInterval(this.refreshRaces, 60000)
  },
  data: function () {
    return {
      loading: true,
      races: [],
      timer: null,
    }
  },
  methods: {
    refreshRaces: function () {
      fetch('/api/v4/speedrunslive_races', {
        mode: 'cors',
      }).then(response => response.json()).then(body => {
        this.loading = false
        this.races = body.races.filter(race => race.statetext !== 'Complete' && race.statetext !== 'Race Over')
      })
    },
  }
}
</script>
