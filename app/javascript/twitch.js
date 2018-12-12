document.addEventListener('turbolinks:load', function() {
  const el = document.getElementById('twitch-player')
  if (el === null) {
    return
  }

  new Twitch.Player('twitch-player', {
    video: gon.run.video_url.split('/').slice(-1)[0],
    muted: true,
    height: '100%',
    width: '100%'
  })
})
