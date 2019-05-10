const resolutionMS = 1000

document.addEventListener('turbolinks:load', () => {
  Array.from(document.querySelectorAll('[data-ms]')).forEach(el => {
    window.setTimeout(() => el.dataset.ms += resolutionMS, resolutionMS)
  })
})
