const async = require('async')

window.onYouTubeIframeAPIReady = () => {
  Array.from(document.querySelectorAll('[data-youtube]')).forEach(el => {
    if (el.dataset.loaded === '1') {
      return
    }
    el.dataset.loaded = '1'

    const player = new YT.Player(el.id, {
      height: '100%',
      width: '100%',
      videoId: el.dataset.video_id,
      events: {
        'onReady': onYoutubePlayerReady
      }
    })
  })
  return true
}

const onYoutubePlayerReady = (event) => {
  const player = event.target
  const el = player.getIframe()

  const startOffset = parseInt(el.dataset.start_offset)
  document.addEventListener('click', clickEvent => {
    const segment = clickEvent.target.closest('.split');
    if (segment === null) {
      return
    }

    player.seekTo(parseInt(segment.dataset.start_ms / 1000) + startOffset)
    setTimeout(function() { player.playVideo() }, 10) // Running this instantly after seek causes the player to hang
  });

  const ticker = document.getElementById(`video-progress-line-${el.dataset.run_id}`)
  async.forever(next => {
    try {
      ticker.style.margin = `0 0 0 ${Math.max(player.getCurrentTime() - startOffset, 0) / (gon.scale_to / 1000) * 100}%`
    } catch {}
    setTimeout(() => next(), 100)
  })
}

const loadYouTubeJSIfNeeded = () => {
  if (document.querySelectorAll('[data-youtube]').length === 0) {
    return
  }

  if (window.YT) {
    // The YouTube API has been loaded once, but Turbolinks and YouTube don't get along, so let's let YouTube do its thing again
    window.YT = undefined
  }
  let tag = document.createElement('script')
  tag.setAttribute('id', 'youtube-async-script')

  tag.src = "https://www.youtube.com/iframe_api"
  let firstScriptTag = document.body.getElementsByTagName('script')[0]
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)

  if (window.YT !== undefined && typeof(window.YT.Player) === "function") {
    onYouTubeIframeAPIReady()
  }
  document.addEventListener("turbolinks:before-cache", function() {
    // Remove the YouTube scripts from the DOM so we don't get 87 copies of it over time
    const ytElement = document.getElementById('www-widgetapi-script')
    if (ytElement) {
      ytElement.remove()
    }
    document.getElementById('youtube-async-script').remove();
    document.removeEventListener("turbolinks:before-cache", arguments.callee)
  })
}

document.addEventListener('turbolinks:load', function() {
  loadYouTubeJSIfNeeded()
})
