$(function() {
  $(".size-chart-item").hover(
    function() {
      $("#split-inspector").html($(this).html());
    },
    function() {
      $("#split-inspector").html("");
    }
  );
});
