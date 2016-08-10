$ ->
  if gon.run.program isnt "livesplit"
    return

  default_color = $(".timeline").children(".split").first().css("background-color")

  split_history_data = ["Mean - Gold"]
  split_history_ticks = []
  $.each gon.run.raw_splits, (i, split) ->
    if split.history is [] or split.history is null
      return
    time = d3.round(d3.mean(split.history) - split.best, 2)
    return if time <= 0
    split_history_data.push time
    split_history_ticks.push split.name
  c3.generate({
    bindto: "#split-history-graph",
    title: { text: "Split History Mean vs Golds" },
    data: {
      columns: [split_history_data],
      type: "bar",
      color: (color, d) -> return default_color
    },
    axis: {
      x: {
        type: "category",
        categories: split_history_ticks,
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
