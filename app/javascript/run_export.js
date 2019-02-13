const setRoutesOnly = function(routesOnly) {
  Array.from(document.getElementById('export-menu').getElementsByClassName('can-strip-history')).forEach((el) => {
    if (routesOnly) {
      el.href = el.href + '?blank=1'
      el.href = `${el.href.split('?')[0]}?${el.href.split('?')[1]}` // Make sure we don't have 2x ?blank=1 due to bugs
    } else {
      el.href = el.href.split('?')[0]
    }
  })
}

document.addEventListener('turbolinks:load', () => {
  const checkbox = document.getElementById('route-check')
  if (checkbox === null) {
    return
  }

  setRoutesOnly(checkbox.checked)

  // Stop clicks on the checkbox's label text from closing the dropdown menu
  document.getElementById('route-check-label').addEventListener('click', (event) => {
    event.stopPropagation()
  })
})

// We can't attach an event listener directly to the element inside a turbolinks:load event.
// See https://github.com/turbolinks/turbolinks#observing-navigation-events
document.addEventListener('click', event => {
  if (event.target.matches('#route-check')) {
    setRoutesOnly(event.target.checked)
  }
})
