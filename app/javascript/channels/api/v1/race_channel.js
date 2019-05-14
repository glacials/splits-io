import consumer from '../../consumer'

let raceSubscription

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
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      switch(data.type) {
        case 'race_entrants_updated':
          document.getElementById('entrants-table').innerHTML = data.data.entrants_html
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

        case 'race_start_scheduled':
          document.getElementById('race-status').innerText = data.data.race.status_text
          hideButton('btn-race-join')
          hideButton('btn-race-leave')
          hideButton('btn-race-ready')
          hideButton('btn-race-unready')
          showButton('btn-race-done')
          showButton('btn-race-forfeit')
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
          document.getElementById('race-status').innerText = data.data.race.status_text
          hideButton('btn-race-forfeit')
          hideButton('btn-race-done')
          hideButton('btn-race-rejoin')
          break;

        case 'new_message':
          document.getElementById('input-list-item').insertAdjacentHTML('afterend', data.data.chat_html)
          break;
        case 'message_creation_error':
          console.error(`Message creation error: ${data.data.message}`)
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

    forfeit() {
      this.perform('forfeit', { server_time: '' })
    },

    done() {
      this.perform('done', { server_time: '' })
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
  if (event.keyCode !== 13) {
    return
  }

  const chatInput = document.getElementById('input-chat-text')
  if (document.activeElement !== chatInput) {
    return
  }

  submitChatInput()
})

const showButton = (elementId) => {
  const elem = document.getElementById(elementId)
  elem.hidden = false
}

const hideButton = (elementId) => {
  const elem = document.getElementById(elementId)
  elem.hidden = true
}

const submitChatInput = () => {
  const chatInput = document.getElementById('input-chat-text')
  if (chatInput.value === '') {
    return
  }

  raceSubscription.sendMessage(chatInput.value)
  chatInput.value = ''
}
