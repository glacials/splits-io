/* eslint no-console: 0 */
import Vue from 'vue/dist/vue.esm'

import TurbolinksAdapter from 'vue-turbolinks'
import VueTippy from 'vue-tippy'

import racebuttons from '../vue/race_buttons.vue'
import racecreate from '../vue/race_create.vue'

Vue.use(TurbolinksAdapter)
Vue.use(VueTippy)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#vue-race',
    components: { racebuttons, racecreate },
  })
})
