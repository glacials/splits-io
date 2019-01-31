const setRoutesOnly = function(routesOnly) {
  Array.from(document.getElementById('export-menu').getElementsByClassName('can-strip-history')).forEach((el) => {
    if (routesOnly) {
      el.href = el.href + '?blank=1'
    } else {
      el.href = el.href.replace('?blank=1', '')
    }
  })
}

document.addEventListener('turbolinks:load', () => {
  checkbox = document.getElementById('route-check')
  if (checkbox === null) {
    return
  }

  setRoutesOnly(checkbox.checked)

  checkbox.addEventListener('change', (event) => {
    setRoutesOnly(event.target.checked)
  })

  // Stop clicks on the checkbox's label text from closing the dropdown menu
  document.getElementById('route-check-label').addEventListener('click', (event) => {
    event.stopPropagation()
  })
})

