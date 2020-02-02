import {setDriftlessInterval} from 'driftless'
const moment = require('moment')
require('moment-duration-format')(moment)

// In this file, we attach to load instead of turbolinks:load because the functions re-find DOM elements every tick, so
// we can re-use the same listener rather than attaching a new one every turbolinks:load. We choose to re-find DOM
// elements every tick because ActionCable can replace our element with a new one rendered server-side at any moment.

// Use data-abstime=<some RFC3339 time> on elements you want to tick up like "01:23:45.678". You can optionally also
// specify a data-abstime-format to use a custom format, such as "HH:mm:ss" to avoid printing milliseconds.
window.addEventListener('load', () => {
  setDriftlessInterval(() => {
    Array.from(document.querySelectorAll('[data-abstime]')).forEach(el => {
      const diffMS = moment().diff(moment(el.dataset.abstime))
      el.textContent = moment.duration(diffMS).format(el.dataset.abstimeFormat || 'HH:mm:ss.SS', {trim: false})
      if (diffMS < 0) {
        el.classList.add('bg-danger')
      } else {
        el.classList.remove('bg-danger')
      }
    })
  }, 10)
})

// Use data-reltime=<some RFC3339 time> on elements you want to tick up like "3 minutes ago".
window.addEventListener('load', () => {
  setInterval(() => {
    Array.from(document.querySelectorAll('[data-reltime]')).forEach(el => {
      el.textContent = moment(el.dataset.reltime).fromNow(true)
    })
  }, 1000)
})
