import {setDriftlessInterval} from 'driftless'
const moment = require('moment')

const resolutionMS = 10

// We attach to load instead of turbolinks:load because this function re-finds DOM elements every tick, so we can re-use
// the same function. We choose to re-find DOM elements every tick because ActionCable can replace our element with a
// new one rendered server-side at any moment.
window.addEventListener('load', () => {
  setDriftlessInterval(() => {
    Array.from(document.querySelectorAll('[data-ms]')).forEach(el => {
      el.dataset.ms = Number(el.dataset.ms) + resolutionMS
      el.textContent = moment.duration(Number(el.dataset.ms)).format('HH:mm:ss.SS', {trim: false})
    })
  }, resolutionMS)
})
