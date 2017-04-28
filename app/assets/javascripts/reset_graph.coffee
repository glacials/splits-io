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

  reset_counter = 0
  reset_data = []
  $.each gon.run.raw_splits, (i, segment) ->
    segment_total_resets = segment.history.filter((h) -> h.duration_seconds == null).length
    # By doing this backwards we allow the loop to not need a special case for index 0
    segment_resets = Math.abs(segment_total_resets - reset_counter)
    if segment_resets > 0
      reset_data.push [segment.name, segment_resets]
      reset_counter = segment_total_resets
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
