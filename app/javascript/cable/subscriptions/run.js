document.addEventListener('turbolinks:load', function() {
  if (window.gon.run) {
    const runSubscription = window.App.cable.subscriptions.create(
      {
        channel: "RunChannel",
        run_id: window.gon.run.id
      },
      {
        received: function(payload) {
          document.getElementById('time-since-upload').textContent = payload.time_since_upload
        }
      }
    )

    document.addEventListener('turbolinks:visit', function() {
      App.cable.subscriptions.remove(runSubscription)
    }, {once: true})
  }
})
