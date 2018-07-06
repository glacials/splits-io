addHovers = ->
  $(".split").hover (->
    $("#" + @id.split("-")[0] + "-inspect-" + @id.split("-")[2]).fadeTo 0, 1
    $("#time").addClass "bar"
  ), ->
    $("#" + @id.split("-")[0] + "-inspect-" + @id.split("-")[2]).fadeTo 0, 0
    $("#time").removeClass "bar"

$(document).ready addHovers
$(document).on 'page:restore', addHovers
