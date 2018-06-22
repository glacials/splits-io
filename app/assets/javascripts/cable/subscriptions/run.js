$(function() {
  if (gon.run) {
    App.cable.subscriptions.create({channel: "RunChannel", run_id: gon.run.id}, {received: function(payload) {
      document.getElementById('time-since-upload').textContent = payload.time_since_upload
    }})
  }
})
