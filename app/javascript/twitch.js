const async = require('async')

document.addEventListener('turbolinks:load', function() {
  Array.from(document.querySelectorAll('[data-twitch]')).forEach(el => {
    if (el.dataset.loaded === '1') {
      return
    }
    el.dataset.loaded = '1'

    const player = new Twitch.Player(el.id, {
      autoplay: false,
      video: el.dataset.video_id,
      muted: true,
      height: '100%',
      width: '100%'
    })

    const startOffset = parseInt(el.dataset.start_offset)
    document.addEventListener('click', event => {
      const segment = event.target.closest('.split')
      if (segment === null) {
        return
      }
      player.seek(parseInt(segment.dataset.start_ms / 1000) + startOffset)
      setTimeout(() => player.play(), 10) // Running this instantly after seek causes the player to hang
    })

    const ticker = document.getElementById(`video-progress-line-${el.dataset.run_id}`)
    async.forever(next => {
      ticker.style.margin = `0 0 0 ${Math.max(player.getCurrentTime() - startOffset, 0) / (gon.scale_to / 1000) * 100}%`
      setTimeout(() => next(), 100)
    })
  })
})
