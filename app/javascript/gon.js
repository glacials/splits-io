document.addEventListener('page:load', function() {
  document.body.gon = window.gon
})

document.addEventListener('page:restore', function() {
  window.gon = document.body.gon
})
