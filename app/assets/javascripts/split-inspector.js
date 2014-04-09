$(function() {
  $('.split').hover(
    function() {
      $('#inspect-' + this.id.split('-')[1]).fadeTo(0, 1);
      $('#time').addClass('bar');
    },
    function() {
      $('#inspect-' + this.id.split('-')[1]).fadeTo(0, 0);
      $('#time').removeClass('bar');
    }
  );
});
