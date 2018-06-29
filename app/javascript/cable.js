import ActionCable from 'actioncable'

(function() {
  this.App || (this.App = {});
  App.cable = ActionCable.createConsumer();
}).call(window)
