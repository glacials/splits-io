document.addEventListener('turbolinks:load', function() {
  Array.from(document.getElementsByClassName('split')).forEach(function(el) {
    el.addEventListener('mouseover', function() {
      document.getElementById(`${el.id.split('-')[0]}-inspect-${el.id.split('-')[2]}`).style.visibility = 'visible'
    })
    el.addEventListener('mouseout', function() {
      document.getElementById(`${el.id.split('-')[0]}-inspect-${el.id.split('-')[2]}`).style.visibility = 'hidden'
    })
  })
})
