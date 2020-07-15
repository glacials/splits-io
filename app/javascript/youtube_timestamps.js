document.addEventListener('input', event => {
  if (event.target.id !== 'video_url') {
    return
  }

  const visibility = RegExp(/^(?:https?:\/\/)?(?:www\.)?youtu(?:be\.com|\.be)\/.+/i).test(event.target.value) ? 'visible' : 'hidden'
  document.getElementById('youtube-timestamps-button').style.visibility = visibility
})

document.addEventListener('click', event => {
  if (event.target.closest('#youtube-timestamps-button') === null) {
    return
  }
  event.preventDefault()
  const moment = require('moment')
  require('moment-duration-format')(moment)

  const offsetInMilliseconds = (document.getElementById('video_start_offset_seconds').value || 0) * 1000
  const textarea = document.getElementById('youtube_timestamps')
  const segments = JSON.parse(textarea.dataset.segments)
  let previous_segment_end = undefined
  const offsets = segments.map((segment) => {
    const start_ms = (segment.start_ms === 0 && previous_segment_end !== undefined) ? previous_segment_end : segment.start_ms
    const duration = start_ms + offsetInMilliseconds
    previous_segment_end = segment.end_ms
    const format = duration < 3600000 ? 'm:ss' : 'H:mm:ss'
    const segmentStart = moment.duration(duration).format(format, {trim: false})
    return `${segmentStart} ${htmlDecode(segment.name)}`
  })
  if (offsetInMilliseconds > 0) {
    offsets.unshift("0:00 Start of Video")
  }
  textarea.value = offsets.join("\n")
  textarea.select()
  document.execCommand("copy")
  return false
})

function htmlDecode(string) {
  const parser = new DOMParser().parseFromString(string, "text/html")
  return parser.documentElement.textContent
}
