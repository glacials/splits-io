$ ->
  if gon.run?
    $.each gon.run.splits, (i, split) ->
      $("#" + gon.run.id + "-split-" + i).each (j, el) ->
        el.style["z-index"] = i
        el.style.width = gon.run.splits[i].duration / gon.scale_to * 100 + "%"

  if gon.comparison_run?
    $.each gon.comparison_run.splits, (i, split) ->
      $("#" + gon.comparison_run.id + "-split-" + i).each (j, el) ->
        el.style["z-index"] = i
        el.style.width = gon.comparison_run.splits[i].duration / gon.scale_to * 100 + "%"
    $('.draggable').draggable axis: 'x', scroll: false
