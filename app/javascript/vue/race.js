const moment = require('moment')
require("moment-duration-format")(moment)

import { applyTips } from '../tooltips'
import { getAccessToken } from '../token'

import consumer from '../channels/consumer'
import raceChat from './race-chat.js'
import raceDisclaimer from './race-disclaimer.js'
import raceTitle from './race-title.js'
import raceStreams from './race-streams.js'

export default {
  components: {
    raceChat,
    raceDisclaimer,
    raceTitle,
    raceStreams,
  },
  created: async function() {
    this.error = false

    const headers = new Headers()
    const accessToken = getAccessToken()
    if (accessToken) {
      headers.append('Authorization', `Bearer ${accessToken}`)
    }

    let url = `/api/v4/races/${this.raceId}`
    const joinToken = (window.gon.race || {}).join_token
    if (joinToken) {
      url += `?join_token=${joinToken}`
    }

    const response = await fetch(url, {
      headers: headers
    })
    if (!response.ok) {
      throw (await response.json()).error || response.statusText
    }

    this.globalSubscription = consumer.subscriptions.create('Api::V4::GlobalRaceChannel', {
      connection() {},

      disconnected() {},

      received(data) {
        this.syncing = false
        switch(data.type) {
          // TODO: update races on game page with this info
          case '...':
            ''
            break;
        }
      }
    })

    this.raceSubscription = consumer.subscriptions.create({
      channel:       'Api::V4::RaceChannel',
      race_id:       this.raceId,
      join_token:    (window.gon.race || {}).join_token
    }, {
      connected: () => {
        // Clean up disconnect if its shown
        // Maybe utilize state to update the page?
      },

      disconnected: () => {
        // Maybe show disconnects?
      },

      received: (data) => {
        this.syncing = false
        switch(data.type) {
          case 'race_entries_updated:html':
            document.getElementById('entries-table').innerHTML = data.data.entries_html
            document.getElementById('stats-box').innerHTML = data.data.stats_html
            applyTips()
            break
          case 'race_entries_updated':
            this.race = data.data.race
            break

          case 'race_start_scheduled:html':
            document.getElementById('stats-box').innerHTML = data.data.stats_html
            if (!starting && new Date(this.race.started_at) > new Date()) {
              this.starting = true
              setTimeout(() => this.starting = false, new Date(this.race.started_at) - new Date())
            }
            break
          case 'race_start_scheduled':
            this.race = data.data.race
            break

          case 'race_updated':
            this.race = data.data.race
            document.getElementById('attachments').innerHTML = data.data.attachments_html
            break

          case 'race_ended':
            this.race = data.data.race
            break

          case 'race_ended:html':
            document.getElementById('entries-table').innerHTML = data.data.entries_html
            document.getElementById('stats-box').innerHTML = data.data.stats_html
            break

          case 'new_message:html':
            document.getElementById('input-list-item').insertAdjacentHTML('afterend', data.data.chat_html)
            applyTips()
            break

          case 'new_attachment:html':
            document.getElementById('attachments').innerHTML = data.data.attachments_html
            break
        }
      }
    })

    document.addEventListener('turbolinks:visit', () => {
      consumer.subscriptions.remove(this.raceSubscription)
    }, {once: true})

    this.race = (await response.json()).race
    this.loading = false
  },
  data: () => ({
    error: false,
    globalSubscription: null,
    loading: true,
    race: null,
    raceSubscription: null,
    starting: false, // true when we're counting down to start, false before & after that
    syncing: false, // true when we know we're waiting on an ActionCable update
  }),
  methods: {
    setSyncing: function() {
      this.syncing = true
    },
  },
  name: 'race',
  props: ['race-id'],
}
