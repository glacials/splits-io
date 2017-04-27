$ ->
  if $("#segment-duration-graph").length is 0 or gon.run.program isnt "livesplit"
    return

  color_styles = [
    "rgba(14, 144, 210, 1)",
    "rgba(128, 87, 165, 1)",
    "rgba(94, 185, 94, 1)",
    "rgba(250, 210, 50, 1)",
    "rgba(221, 81, 76, 1)",
    "rgba(243, 123, 29, 1)"
  ]

  seg_histories = []
  hidden_data = []
  first_non_null_attempt = Infinity

  $.each gon.run.raw_splits, (i, split) ->
    non_null_time_inserted = false
    attempt_durations = []
    $.each split.history, (j, attempt) ->
      if non_null_time_inserted || attempt.duration_seconds != null
        non_null_time_inserted = true
        attempt_durations.push(attempt.duration_seconds)

        if j < first_non_null_attempt
          first_non_null_attempt = j
      else
        attempt_durations.push(null)

    seg_histories.push(JSON.parse(JSON.stringify(attempt_durations)))
    seg_histories[i].unshift(split.name)

    if seg_histories.length > 1
      hidden_data.push split.name
  c3.generate({
    bindto: "#segment-duration-graph",
    title: {
      text: "Segment Durations Over Time (choose segments below)"
    },
    data: {
      columns: seg_histories,
      hide: hidden_data,
    },
    subchart: {
      show: true
    },
    size: {
      height: 320 * ((gon.run.raw_splits.length / 60) + 1)
    },
    color: {
      pattern: color_styles
    },
    line: {
      connectNull: true
    },
    axis: {
      x: {
        type: "category",
        categories: index + 1 for split, index in gon.run.history
        tick: {
          culling: true,
          multiline: false
        },
        label: {
          text: "Attempt Number",
          position: "outer-center"
        },
        min: first_non_null_attempt
      },
      y: {
        label: {
          text: "Duration of History",
          position: "outer-middle"
        },
        tick: {
          format: (d) ->
            moment.utc(moment.duration(d, "seconds").asMilliseconds()).format("H:mm:ss")
        }
      }
    }
  })
