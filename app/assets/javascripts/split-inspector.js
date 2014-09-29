$(function() {
  $(".split").hover(function() {
    $("#" + this.id.split("-")[0] + "-inspect-" + this.id.split("-")[2]).fadeTo(0, 1);
    $("#time").addClass("bar");
    var colors = ["blue", "purple", "green", "red", "orange", "yellow"]
    mixpanel.track("hovered over a split", {
      "split color": colors[this.id.split("-")[2] % colors.length],
      "split width": this.offsetWidth / window.innerWidth,
      "run time": gon.run.time,
      "game": gon.run.game.name,
      "category": gon.run.category.name,
      "runner": (gon.run.user || {}).name,
      "number of splits": gon.run.splits.length
    });
  }, function() {
    $("#" + this.id.split("-")[0] + "-inspect-" + this.id.split("-")[2]).fadeTo(0, 0);
    $("#time").removeClass("bar");
  });
});
