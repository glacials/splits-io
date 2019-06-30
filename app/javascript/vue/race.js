const moment = require('moment')
require("moment-duration-format")(moment)

import { applyTips } from '../tooltips'
import { ts } from '../time'

import consumer from '../channels/consumer'
import raceChat from './race-chat.js'
import raceDisclaimer from './race-disclaimer.js'
import raceNav from './race-nav.js'

export default {
  components: {
    raceChat,
    raceDisclaimer,
    raceNav
  },
  created: async function() {
    this.error = false

    const headers = new Headers()
    if (localStorage.getItem('splitsio_access_token')) {
      headers.append('Authorization', `Bearer ${localStorage.getItem('splitsio_access_token')}`)
    }

    let url = `/api/v4/${this.raceableType}s/${this.raceableId}`
    let join_token = window.gon.race.join_token
    if (!join_token) {
      join_token = new URLSearchParams(window.location.search).get('join_token')
    }
    if (join_token) {
      url = `${url}?join_token=${join_token}`
    }

    const response = await fetch(url, {
      headers: headers
    })
    if (!response.ok) {
      throw (await response.json()).error || response.statusText
    }

    this.globalSubscription = consumer.subscriptions.create('Api::V4::GlobalRaceableChannel', {
      connection() {},

      disconnected() {},

      received(data) {
        switch(data.type) {
          // TODO: update races on game page with this info
          case '...':
            ''
            break;
        }
      }
    })

    this.raceSubscription = consumer.subscriptions.create({
      channel:       'Api::V4::RaceableChannel',
      raceable_id:   this.raceableId,
      raceable_type: this.raceableType,
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
        switch(data.type) {
          case 'raceable_entries_updated:html':
            document.getElementById('entries-table').innerHTML = data.data.entries_html
            document.getElementById('stats-box').innerHTML = data.data.stats_html
            break

          case 'raceable_start_scheduled:html':
            document.getElementById('stats-box').innerHTML = data.data.stats_html
            break
          case 'raceable_start_scheduled':
            this.raceable = data.data.raceable
            break

          case 'raceable_ended':
            this.raceable = data.data.raceable
            break;
          case 'raceable_ended:html':
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

          case 'new_card':
            document.getElementById('card-url').innerText = data.data.raceable.card_url
            break
        }
      }
    })

    document.addEventListener('turbolinks:visit', () => {
      consumer.subscriptions.remove(this.raceSubscription)
    }, {once: true})

    this.raceable = (await response.json())[this.raceableType]
    this.loading = false
  },
  data: () => ({
    error: false,
    globalSubscription: null,
    loading: true,
    raceable: null,
    raceSubscription: null,
  }),
  methods: {
  },
  name: 'race',
  props: ['raceable-type', 'raceable-id'],
}
