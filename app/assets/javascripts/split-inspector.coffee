$ ->
  $(".split").hover (->
    $("#" + @id.split("-")[0] + "-inspect-" + @id.split("-")[2]).fadeTo 0, 1
    $("#time").addClass "bar"
    colors = [ "blue", "purple", "green", "red", "orange", "yellow" ]
  ), ->
    $("#" + @id.split("-")[0] + "-inspect-" + @id.split("-")[2]).fadeTo 0, 0
    $("#time").removeClass "bar"
