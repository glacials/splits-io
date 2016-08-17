$ ->
  if $("#reset-graph").length is 0 or gon.run.program isnt "livesplit"
    return

  color_styles = [
    "rgba(14, 144, 210, 1)",
    "rgba(128, 87, 165, 1)",
    "rgba(94, 185, 94, 1)",
    "rgba(221, 81, 76, 1)",
    "rgba(243, 123, 29, 1)",
  ]

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
    },
    color: { pattern: color_styles },
    donut: {
      title: "Resets/Split",
      label: { format: (v) -> return v }
    },
    tooltip: {
      format: { value: (value, ratio) -> return "#{value} | #{d3.round(ratio * 100, 1)}%" }
    }
  })
