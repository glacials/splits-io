import consumer from '../../consumer'

document.addEventListener('turbolinks:load', () => {
  consumer.subscriptions.create('Api::V4::GlobalRaceableChannel', {
    connection() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      switch(data.type) {
        // TODO: update races on game page with this info
        case '...':
          ''
          break;
      }
    }
  })
}, {once: true})
