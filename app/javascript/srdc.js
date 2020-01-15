document.addEventListener('turbolinks:load', function() {
  if ((new URLSearchParams(window.location.search)).has('srdc_submit')) {
    $('#srdc-submit').modal('show')
  }
})
