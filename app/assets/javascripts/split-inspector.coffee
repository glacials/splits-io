$ ->
  $(".split").hover (->
    $("#inspect-" + @id.split("-")[1]).fadeTo 0, 1
    $("#time").addClass "bar"
    return
  ), ->
    $("#inspect-" + @id.split("-")[1]).fadeTo 0, 0
    $("#time").removeClass "bar"
    return

  return

