const moment = require('moment')

import consumer from '../../consumer'
import { createAlert, showButton, hideButton } from '../../../dom_helpers'
import { ts } from '../../../time'

let raceSubscription
let isConnected = false

document.addEventListener('turbolinks:load', () => {
  if (!window.gon || !window.gon.race) {
    return
  }

  raceSubscription = consumer.subscriptions.create({
    channel:    'Api::V1::RaceChannel',
    race_id:    window.gon.race.id,
    race_type:  window.gon.race.type,
    join_token: window.gon.race.join_token
  }, {
    connected() {
      isConnected = true
      const alert = document.getElementById('disconnected-alert')
      if (alert) {
        alert.parentNode.removeChild(alert)
      }

      const forfeitTime = localStorage.getItem(`race-${window.gon.race.id}-forfeit-time`)
      if (forfeitTime) {
        this.forfeit(parseFloat(forfeitTime))
        localStorage.removeItem(`race-${window.gon.race.id}-forfeit-time`)
      }

      const doneTime = localStorage.getItem(`race-${window.gon.race.id}-done-time`)
      if (doneTime) {
        this.done(parseFloat(doneTime))
        localStorage.removeItem(`race-${window.gon.race.id}-done-time`)
      }
    },

    disconnected() {
      isConnected = false
      const alert = createAlert('danger', 'Disconnected')
      alert.setAttribute('id', 'disconnected-alert')
      document.getElementById('alerts').appendChild(alert)
    },

    received(data) {
      switch(data.type) {
        case 'race_entrants_updated':
          document.getElementById('entrants-table').innerHTML = data.data.entrants_html
          document.getElementById('stats-box').innerHTML = data.data.stats_html
          break;

        case 'race_join_success':
          hideButton('btn-race-join')
          showButton('btn-race-leave')
          showButton('btn-race-ready')
          break;
        case 'race_leave_success':
          hideButton('btn-race-leave')
          showButton('btn-race-join')
          hideButton('btn-race-ready')
          hideButton('btn-race-unready')
          break;
        case 'race_ready_success':
          hideButton('btn-race-ready')
          showButton('btn-race-unready')
          break;
        case 'race_unready_success':
          showButton('btn-race-ready')
          hideButton('btn-race-unready')
          break;

        case 'race_read_only':
          const readAlert = createAlert('warning', 'You will not be able to join this race')
          document.getElementById('alerts').appendChild(readAlert)
          setTimeout(() => { readAlert.parentNode.removeChild(readAlert) }, 5000)
          break;
        case 'race_start_scheduled':
          document.getElementById('stats-box').innerHTML = data.data.stats_html
          hideButton('btn-race-join')
          hideButton('btn-race-leave')
          hideButton('btn-race-ready')
          hideButton('btn-race-unready')
          showButton('btn-race-done')
          showButton('btn-race-forfeit')
          const duration = moment.duration(moment(data.data.race.started_at).valueOf() - ts.now())
          const startAlert = createAlert('warning', `Race starting in ${duration.format('s [seconds]')}!`)
          startAlert.setAttribute('data-start', data.data.race.started_at)
          document.getElementById('alerts').appendChild(startAlert)
          countdown(startAlert)
          break;
        case 'race_done_success':
          hideButton('btn-race-done')
          hideButton('btn-race-forfeit')
          showButton('btn-race-rejoin')
          break;
        case 'race_forfeit_success':
          hideButton('btn-race-done')
          hideButton('btn-race-forfeit')
          showButton('btn-race-rejoin')
          break;
        case 'race_rejoin_success':
          showButton('btn-race-done')
          showButton('btn-race-forfeit')
          hideButton('btn-race-rejoin')
          break;

        case 'race_ended':
          document.getElementById('entrants-table').innerHTML = data.data.entrants_html
          document.getElementById('stats-box').innerHTML = data.data.stats_html
          hideButton('btn-race-forfeit')
          hideButton('btn-race-done')
          hideButton('btn-race-rejoin')
          break;

        case 'new_message':
          document.getElementById('input-list-item').insertAdjacentHTML('afterend', data.data.chat_html)
          break;

        case 'new_attachment':
          document.getElementById('attachments').innerHTML = data.data.attachments_html
          break;

        case 'race_started_error':
        case 'race_join_error':
        case 'in_race_error':
        case 'race_leave_error':
        case 'race_ready_error':
        case 'race_unready_error':
        case 'race_not_started_error':
        case 'race_finished_error':
        case 'race_done_error':
        case 'race_forfeit_error':
        case 'race_rejoin_error':
        case 'message_creation_error':
        case 'fatal_error':
          const errorAlert = createAlert('danger', `Error: ${data.data.message}`)
          document.getElementById('alerts').appendChild(errorAlert)
          setTimeout(() => { errorAlert.parentNode.removeChild(errorAlert) }, 5000)
          break;
      }
    },

    join() {
      this.perform('join')
    },

    leave() {
      this.perform('leave')
    },

    ready() {
      this.perform('ready')
    },

    unready() {
      this.perform('unready')
    },

    forfeit(time) {
      if (isConnected) {
        if (!time) {
          time = ts.now()
        }
        this.perform('forfeit', { server_time: time })
      } else {
        localStorage.setItem(`race-${window.gon.race.id}-forfeit-time`, ts.now())
      }
    },

    done(time) {
      if (isConnected) {
        if (!time) {
          time = ts.now()
        }
        this.perform('done', { server_time: time })
      } else {
        localStorage.setItem(`race-${window.gon.race.id}-done-time`, ts.now())
      }
    },

    rejoin() {
      this.perform('rejoin')
    },

    sendMessage(message) {
      this.perform('send_message', { body: message })
    }
  })

  document.addEventListener('turbolinks:visit', () => {
    consumer.subscriptions.remove(raceSubscription)
  }, {once: true})
})

document.addEventListener('click', (event) => {
  if (event.target.matches('#btn-race-join')) {
    raceSubscription.join()
  }
  if (event.target.matches('#btn-race-leave')) {
    raceSubscription.leave()
  }
  if (event.target.matches('#btn-race-ready')) {
    raceSubscription.ready()
  }
  if (event.target.matches('#btn-race-unready')) {
    raceSubscription.unready()
  }
  if (event.target.matches('#btn-race-done')) {
    raceSubscription.done()
  }
  if (event.target.matches('#btn-race-forfeit')) {
    raceSubscription.forfeit()
  }
  if (event.target.matches('#btn-race-rejoin')) {
    raceSubscription.rejoin()
  }

  if (event.target.matches('#btn-chat-submit')) {
    submitChatInput()
  }
})

document.addEventListener('keypress', (event) => {
  if (event.keyCode !== 13 || event.shiftKey) {
    return
  }

  const chatInput = document.getElementById('input-chat-text')
  if (document.activeElement !== chatInput) {
    return
  }

  submitChatInput()
})

const submitChatInput = () => {
  const chatInput = document.getElementById('input-chat-text')
  if (chatInput.value === '') {
    return
  }

  raceSubscription.sendMessage(chatInput.value)
  chatInput.value = ''
}

const countdown = (alert) => {
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
