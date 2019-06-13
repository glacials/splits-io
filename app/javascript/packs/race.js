/* eslint no-console: 0 */
import Vue from 'vue/dist/vue.esm'

import TurbolinksAdapter from 'vue-turbolinks'
import VueTippy from 'vue-tippy'

import race from '../vue/race.js'
import raceCreate from '../vue/race-create.js'

Vue.use(TurbolinksAdapter)
Vue.use(VueTippy)

document.addEventListener('turbolinks:load', () => {
  if (document.getElementById('vue-race') === null) {
    return
  }

  const app = new Vue({
    el: '#vue-race',
    components: { race, raceCreate },
  })
})
