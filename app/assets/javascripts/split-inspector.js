$(function() {
  $(".split").hover(function() {
    $("#" + this.id.split("-")[0] + "-inspect-" + this.id.split("-")[2]).fadeTo(0, 1);
    $("#time").addClass("bar");
    var colors = ["blue", "purple", "green", "red", "orange", "yellow"]
  }, function() {
    $("#" + this.id.split("-")[0] + "-inspect-" + this.id.split("-")[2]).fadeTo(0, 0);
    $("#time").removeClass("bar");
  });
});
