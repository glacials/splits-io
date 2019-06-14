const moment = require('moment')
require("moment-duration-format")(moment)

import { applyTips } from '../tooltips'
import { createAlert } from '../dom_helpers'
import { ts } from '../time'

import consumer from '../channels/consumer'
import raceChat from './race-chat.js'
import raceNav from './race-nav.js'

let raceSubscription

export default {
  components: {
    raceChat,
    raceNav
  },
  created: async function() {
    this.loading = true
    this.error = false

    const countdown = alert => {
      const interval = setInterval(() => {
        const duration = moment.duration(moment(alert.dataset.start).valueOf() - ts.now())
        if (duration.asSeconds() <= 0) {
          clearInterval(interval)
          alert.innerText = 'Race Started!'
          alert.classList.remove('alert-warning')
          alert.classList.add('alert-success')
          setTimeout(() => { alert.parentNode.removeChild(alert) }, 10000)
          return
        }

        alert.innerText = `Race starting in ${duration.format('s [seconds]')}!`
      }, 100)
    }

    const response = await fetch(`/api/v4/${this.raceableType}s/${this.raceableId}`, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('splitsio_access_token')}`,
      },
    })
    if (!response.ok) {
      throw (await response.json()).error || response.statusText
    }


    if (!window.gon || !window.gon.race) {
      return
    }

    raceSubscription = consumer.subscriptions.create({
      channel:    'Api::V4::RaceChannel',
      race_id:    window.gon.race.id,
      race_type:  window.gon.race.type,
      join_token: window.gon.race.join_token
    }, {
      connected: () => {
        const alert = document.getElementById('disconnected-alert')
        if (alert) {
          alert.parentNode.removeChild(alert)
        }
      },

      disconnected: () => {
        const alert = createAlert('danger', 'Disconnected')
        alert.setAttribute('id', 'disconnected-alert')
        document.getElementById('alerts').appendChild(alert)
      },

      received: (data) => {
        switch(data.type) {
          case 'race_entrants_updated:html':
            document.getElementById('entrants-table').innerHTML = data.data.entrants_html
            document.getElementById('stats-box').innerHTML = data.data.stats_html
            break

          case 'race_start_scheduled:html':
            document.getElementById('stats-box').innerHTML = data.data.stats_html
            break
          case 'race_start_scheduled':
            this.raceable = data.data.race
            const duration = moment.duration(moment(data.data.race.started_at).valueOf() - ts.now())
            const startAlert = createAlert('warning', `Race starting in ${duration.format('s [seconds]')}!`)
            startAlert.setAttribute('data-start', data.data.race.started_at)
            document.getElementById('alerts').appendChild(startAlert)
            countdown(startAlert)
            break

          case 'race_ended:html':
            document.getElementById('entrants-table').innerHTML = data.data.entrants_html
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
      consumer.subscriptions.remove(raceSubscription)
    }, {once: true})

    this.raceable = (await response.json())[this.raceableType]
    this.loading = false
  },
  data: () => ({
    error: false,
    loading: false,
    raceable: null,
  }),
  methods: {
  },
  name: 'race',
  props: ['raceable-type', 'raceable-id'],
}
