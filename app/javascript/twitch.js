const async = require('async')

document.addEventListener('turbolinks:load', function() {
  Array.from(document.getElementsByClassName('twitch-player')).forEach(el => {
    if (el.dataset.loaded === '1') {
      return
    }
    el.dataset.loaded = '1'

    const player = new Twitch.Player(el.id, {
      autoplay: false,
      video: el.dataset.video_url.split('/').slice(-1)[0],
      muted: true,
      height: '100%',
      width: '100%'
    })


    document.addEventListener('click', event => {
      const segment = event.target.closest('.split')
      if (segment === null) {
        return
      }

      player.seek(parseInt(segment.dataset.start_ms / 1000 + 10))
      setTimeout(() => player.play(), 10) // Running this instantly after seek causes the player to hang
    })

    const ticker = document.getElementById(`video-progress-line-${el.dataset.run_id}`)
    async.forever(next => {
      ticker.style.margin = `0 0 0 ${Math.max(player.getCurrentTime() - 10, 0) / (gon.scale_to / 1000) * 100}%`
      setTimeout(() => next(), 100)
    })
  })
})
