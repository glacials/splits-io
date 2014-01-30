$(function() {
  $('.split').hover(
    function() {
      $('#inspector-' + this.id.split('-')[1]).fadeTo(0, 1);
      $('#time').fadeTo(0, 1);
    },
    function() {
      $('#inspector-' + this.id.split('-')[1]).fadeTo(0, 0);
      $('#time').fadeTo(0, 0);
    }
  );
});
