$ ->
  if gon.run.program isnt "livesplit"
    return

  colors_obj = {}
  $(".timeline").children(".split").each (index) ->
    color = $(this).css("background-color")
    return if color is "rgba(0, 0, 0, 0)"
    colors_obj[$(this).children()[0].innerHTML] = color

  reset_counter = gon.run.attempts
  reset_data = []
  $.each gon.run.raw_splits, (i, split) ->
    split_resets = reset_counter - split.history.length
    if split_resets > 0
      reset_data.push [split.name, split_resets]
      reset_counter = split.history.length
  c3.generate({
    bindto: "#reset-graph",
    data: {
      columns: reset_data,
      type: "donut",
      color: (color, d) -> return if d.id then color else colors_obj[d]
    },
    donut: {
      title: "Resets/Split",
      label: { format: (v) -> return v }
    },
    tooltip: {
      format: { value: (value, ratio) -> return "#{value} | #{d3.round(ratio * 100, 1)}%" }
    }
  })
