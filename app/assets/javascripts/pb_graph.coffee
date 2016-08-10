$ ->
  if not gon.run.raw_splits?
    return
  default_color = $(".timeline").children(".split").first().css("background-color")

  pb_graph_data = ["PB - Gold"]
  pb_graph_ticks = []
  $.each gon.run.splits, (i, split) ->
    time = d3.round(split.duration - split.best, 2)
    return if time <= 0
    pb_graph_data.push time
    pb_graph_ticks.push split.name
  pb_graph = c3.generate({
    bindto: "#pb-graph",
    title: { text: "PB vs Golds" },
    data: {
      columns: [pb_graph_data],
      type: "bar",
      color: (color, d) -> return default_color
    },
    axis: {
      x: {
        type: "category",
        categories: pb_graph_ticks,
        tick: {
          rotate: -45,
          multiline: false
        },
        height: 80
      },
      y: {
        label: {
          text: "Possible Time Save",
          position: "outer-middle"
        },
        tick: {
          format: (d) -> return d + "s"
        }
      }
    },
    legend: { hide: true }
  })
