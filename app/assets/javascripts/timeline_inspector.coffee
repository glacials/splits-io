$ ->
  $(".segment").hover (->
    $("#" + this.id.replace("segment", "inspect")).fadeTo 0, 1
    $("#time").addClass "bar"
  ), ->
    $("#" + this.id.replace("segment", "inspect")).fadeTo 0, 0
    $("#time").removeClass "bar"
