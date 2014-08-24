$ ->
  $(".split").hover (->
    $("#" + @id.split("-")[0] + "-inspect-" + @id.split("-")[2]).fadeTo 0, 1
    $("#time").addClass "bar"
    return
  ), ->
    $("#" + @id.split("-")[0] + "-inspect-" + @id.split("-")[2]).fadeTo 0, 0
    $("#time").removeClass "bar"
    return

  return

