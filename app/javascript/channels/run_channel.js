import consumer from './consumer'

document.addEventListener('turbolinks:load', () => {
  if (!window.gon || !window.gon.run) {
    return
  }

  const runSubscription = consumer.subscriptions.create({channel: 'RunChannel', run_id: window.gon.run.id}, {
    received(payload) {
      document.getElementById('time-since-upload').textContent = payload.time_since_upload
    }
  })

  document.addEventListener('turbolinks:visit', () => {
    consumer.subscriptions.remove(runSubscription)
  }, {once: true})
})
