$ ->
  if gon.run isnt `undefined`
    $.each gon.run.segments, (i, segment) ->
      $("#run" + gon.run.id36 + "-segment" + i).each (j, el) ->
        el.style["z-index"] = i
        el.style.width = gon.run.segments[i].real_duration / gon.scale_to * 100 + "%"

  if gon.comparison_run isnt `undefined`
    $.each gon.comparison_run.segments, (i, segment) ->
      $("#run" + gon.comparison_run.id36 + "-segment" + i).each (j, el) ->
        el.style["z-index"] = i
        el.style.width = gon.comparison_run.segments[i].real_duration / gon.scale_to * 100 + "%"
