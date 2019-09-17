const async = require('async')

window.onYouTubeIframeAPIReady = () => {
  return true
}

function setupYouTubeVideos() {
  Array.from(document.querySelectorAll('[data-youtube]')).forEach(el => {
    if (el.dataset.loaded === '1') {
      return
    }
    el.dataset.loaded = '1'

    const player = new YT.Player(el.id, {
      height: '100%',
      width: '100%',
      videoId: el.dataset.video_id
    });

    document.addEventListener('click', event => {
      const segment = event.target.closest('.split');
      if (segment === null) {
        return
      }

      player.seekTo(parseInt(segment.dataset.start_ms / 1000 + 10))
      setTimeout(function() { player.playVideo() }, 10) // Running this instantly after seek causes the player to hang
    });

    const ticker = document.getElementById(`video-progress-line-${el.dataset.run_id}`)
    async.forever(next => {
      try {
        ticker.style.margin = `0 0 0 ${Math.max(player.getCurrentTime() - 10, 0) / (gon.scale_to / 1000) * 100}%`
      } catch {}
      setTimeout(() => next(), 100)
    })
  })
}

// TODO: Is there a way we can deal with YouTube's async loading
// and Turbolinks without polling?
function waitForYouTubeAPI() {
  if (window.YT !== undefined && typeof(window.YT.Player) === "function") {
    setupYouTubeVideos()
    return true
  }
  setTimeout(waitForYouTubeAPI, 100)
}

document.addEventListener('turbolinks:load', function() {
  waitForYouTubeAPI()
})
