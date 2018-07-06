import ActionCable from 'actioncable'

document.addEventListener('turbolinks:load', function() {
  window.App || (window.App = {})
  window.App.cable || (window.App.cable = ActionCable.createConsumer())
})
