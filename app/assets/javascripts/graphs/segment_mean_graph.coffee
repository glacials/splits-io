$ ->
  if $("#split-history-graph").length is 0 or gon.run.program isnt "livesplit"
    return

  color_styles = ["rgba(14, 144, 210, 1)"]

  split_history_data = ["Mean - Gold"]
  split_history_ticks = []
  $.each gon.run.segments, (i, segment) ->
    if segment.histories is [] or segment.histories is null
      return
    attempt_durations = segment.histories.map((attempt) -> attempt['duration_ms'])
    time = (d3.mean(attempt_durations) - segment.shortest_duration_ms) / 1000
    return if time <= 0
    split_history_data.push time
    split_history_ticks.push segment.name
  c3.generate({
    bindto: "#split-history-graph",
    title: { text: "Split History Mean vs Golds" },
    data: {
      columns: [split_history_data],
      type: "bar",
    },
    color: { pattern: color_styles },
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
