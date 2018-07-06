document.addEventListener('turbolinks:load', function() {
  for(el of document.getElementsByClassName('split')) {
    el.addEventListener('mouseover', function() {
      document.getElementById(el.id.split('-')[0] + '-inspect-' + el.id.split('-')[2]).style.display = null
    })
    el.addEventListener('mouseout', function() {
      document.getElementById(el.id.split('-')[0] + '-inspect-' + el.id.split('-')[2]).style.display = 'none'
    })
  }
})
