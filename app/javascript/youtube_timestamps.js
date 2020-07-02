document.addEventListener('input', event => {
  if (event.target.id !== 'youtube_start_offset') {
    return
  }

  const offsetMilliseconds = (event.target.value || 0) * 1000;
  displayYoutubeTimestamps(offsetMilliseconds, 'youtube_timestamps');
})

window.displayYoutubeTimestamps = (offsetInMilliseconds, textareaId) => {
  const moment = require('moment')
  require('moment-duration-format')(moment)

  const textarea = document.getElementById(textareaId);
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
}

function htmlDecode(string) {
  const parser = new DOMParser().parseFromString(string, "text/html");
  return parser.documentElement.textContent
}
