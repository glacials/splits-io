document.addEventListener('input', event => {
  if (event.target.id !== 'video_url') {
    return
  }

  const visibility = RegExp(/^(?:https?:\/\/)?(?:www\.)?youtu(?:be\.com|\.be)\/.+/i).test(event.target.value) ? 'visible' : 'hidden'
  document.getElementById('youtube-timestamps').style.visibility = visibility
})

window.copyYoutubeTimestamps = () => {
  const moment = require('moment')
  require('moment-duration-format')(moment)

  const offsetInMilliseconds = (document.getElementById('video_start_offset_seconds').value || 0) * 1000
  const textarea = document.getElementById('youtube_timestamps');
  const segments = JSON.parse(textarea.dataset.segments);
  const offsets = segments.map((segment) => {
    const duration = segment.start_ms + offsetInMilliseconds
    const format = duration < 3600000 ? 'm:ss' : 'H:mm:ss';
    const segmentStart = moment.duration(duration).format(format, {trim: false});
    return `${segmentStart} ${htmlDecode(segment.name)}`
  })
  if (offsetInMilliseconds > 0) {
    offsets.unshift("0:00 Start of Video");
  }
  textarea.value = offsets.join("\n")
  textarea.select();
  document.execCommand("copy");
}

function htmlDecode(string) {
  const parser = new DOMParser().parseFromString(string, "text/html");
  return parser.documentElement.textContent
}
