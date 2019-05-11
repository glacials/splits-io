import consumer from '../../consumer'

let chatSubscription

document.addEventListener('turbolinks:load', () => {
  if (!window.gon || !window.gon.chat_room) {
    return
  }

  chatSubscription = consumer.subscriptions.create({
    channel:      'Api::V1::ChatChannel',
    chat_room_id: window.gon.chat_room.id
  }, {
      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {

      },

      sendMessage(text) {
        this.perform('send_message', { text: text })
      }
  })

  document.addEventListener('turbolinks:visit', () => {
    consumer.subscriptions.remove(chatSubscription)
  }, {once: true})
})
