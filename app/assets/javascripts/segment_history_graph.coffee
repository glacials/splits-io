$ ->
  if gon.run.program isnt "livesplit"
    return

  colors_obj = {}
  $(".timeline").children(".split").each (index) ->
    color = $(this).css("background-color")
    return if color is "rgba(0, 0, 0, 0)"
    colors_obj[$(this).children()[0].innerHTML] = color

  seg_histories = []
  $.each gon.run.raw_splits, (i, split) ->
    seg_histories.push JSON.parse(JSON.stringify(split.history))
    seg_histories[i].unshift split.name
  c3.generate({
    bindto: "#segment-duration-graph",
    title: { text: "Segment Histories Over Time"},
    data: {
      columns: seg_histories,
      color: (color, d) -> return if d.id then colors_obj[d.id] else colors_obj[d]
    }
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
