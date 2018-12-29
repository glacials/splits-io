document.addEventListener('turbolinks:load', function() {
  const el = document.getElementById('twitch-player')
  if (el === null) {
    return
  }

  const player = new Twitch.Player('twitch-player', {
    video: gon.run.video_url.split('/').slice(-1)[0],
    muted: true,
    height: '100%',
    width: '100%'
  })

  Array.from(document.getElementsByClassName('split')).forEach(function(el) {
    el.addEventListener('click', function() {
      player.seek(parseInt(el.dataset.startMs / 1000 + 10))
      player.play()
    })
  })
})
