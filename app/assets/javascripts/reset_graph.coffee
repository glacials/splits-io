$ ->
  if $("#reset-graph").length is 0 or gon.run.program isnt "livesplit"
    return

  color_styles = [
    "rgba(14, 144, 210, 1)",
    "rgba(128, 87, 165, 1)",
    "rgba(94, 185, 94, 1)",
    "rgba(250, 210, 50, 1)",
    "rgba(221, 81, 76, 1)",
    "rgba(243, 123, 29, 1)"
  ]

  reset_counter = gon.run.history.length
  reset_data = []
  $.each gon.run.splits, (i, segment) ->
    segment_resets = reset_counter - segment.history.filter((h) -> h.duration_seconds == null).length
    if segment_resets > 0
      reset_data.push [segment.name, segment_resets]
      reset_counter = segment.history.length
  c3.generate({
    bindto: "#reset-graph",
    data: {
      columns: reset_data,
      type: "donut",
    },
    color: {
      pattern: color_styles
    },
    donut: {
      title: "Resets/Split",
      label: {
        format: (v) ->
          return v
      }
    },
    tooltip: {
      format: {
        value: (value, ratio) ->
          return "#{value} | #{d3.round(ratio * 100, 1)}%"
      }
    }
  })
