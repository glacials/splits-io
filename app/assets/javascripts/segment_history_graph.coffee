$ ->
  if $("#segment-duration-graph").length is 0 or gon.run.program isnt "livesplit"
    return

  color_styles = [
    "rgba(14, 144, 210, 1)",
    "rgba(128, 87, 165, 1)",
    "rgba(94, 185, 94, 1)",
    "rgba(221, 81, 76, 1)",
    "rgba(243, 123, 29, 1)",
  ]

  seg_histories = []
  hidden_data = []
  $.each gon.run.raw_splits, (i, split) ->
    seg_histories.push JSON.parse(JSON.stringify(split.history))
    seg_histories[i].unshift split.name
    if seg_histories.length > 15 then hidden_data.push split.name
  c3.generate({
    bindto: "#segment-duration-graph",
    title: { text: "Segment Histories Over Time"},
    data: {
      columns: seg_histories,
      hide: hidden_data
    },
    color: { pattern: color_styles },
    axis: {
      x: {
        type: "category",
        categories: index + 1 for split, index in gon.run.history
        tick: {
          culling: true,
          multiline: false
        }
      },
      y: {
        label: {
          text: "Duration of History",
          position: "outer-middle"
        },
        tick: {
          format: (d) -> moment.utc(moment.duration(d, "seconds").asMilliseconds()).format("H:mm:ss")
        }
      }
    }
  })
