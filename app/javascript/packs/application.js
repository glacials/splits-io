/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import "jquery"
require("@rails/activestorage").start()
require("@rails/ujs").start()
require("turbolinks").start()
require("channels")
const moment = require('moment')
const momentDurationFormatSetup = require('moment-duration-format')

momentDurationFormatSetup(moment)

import Vue from 'vue/dist/vue.esm'

import TurbolinksAdapter from 'vue-turbolinks'
import VueTippy, { TippyComponent } from 'vue-tippy'

import race from '../vue/race.js'
import RaceCreateButton from '../vue/RaceCreateButton.vue'
import EditRunGameAndCategory from '../vue/EditRunGameAndCategory.vue'
import Search from '../vue/Search.vue'
import SpeedRunsLiveRaceList from '../vue/SpeedRunsLiveRaceList.vue'

Vue.use(TurbolinksAdapter)
Vue.use(VueTippy, {
  onShow: instance => {
    if (!instance.props.content) {
      return false
    } // Makes null `content` hide the tooltip, not show a blank one
  },
})
Vue.component("tippy", TippyComponent);

document.addEventListener('turbolinks:load', () => {
  if (!document.getElementById('vue')) {
    return
  }

  const app = new Vue({
    el: '#vue',
    components: { race, RaceCreateButton, EditRunGameAndCategory, Search, SpeedRunsLiveRaceList },
  })
})

// Using Google charts for admin dashboards for now (a script tag in app/views/layouts/admin/application.slim) because
// Chartkick + Highcharts doesn't seem to include axes, and tooltips don't include years (?) with no clear resolution
import Chartkick from "chartkick"
window.Chartkick = Chartkick

import 'bootstrap'

import "../analytics.js"
import "../banner.js"
import "../collapse.js"
import "../count.js"
// import "../crisp.js"
import "../dropdown.js"
import "../highchart_theme.js"
import "../chart_builder.js"
import "../landing.js"
import "../like.js"
import "../race_attach.js"
import "../run_claim.js"
import '../run_delete.js'
import '../run_disown.js'
import "../run_export.js"
import "../run_parse.js"
import "../settings.js"
import "../srdc.js"
import "../stripe.js"
import "../paypal.js"
import "../survey.js"
import "../timeline.js"
import "../token.js"
import "../tooltips.js"
import "../twitch.js"
import "../upload.js"
import "../youtube.js"
import "../youtube_timestamps.js"
