$ ->
  if gon.run.program isnt "livesplit"
    return
  console.log "heello there"

  default_color = $(".timeline").children(".split").first().css("background-color")

  duration_data = gon.run.history.map((time) -> return time)
  duration_data.unshift "Run Length"
  c3.generate({
    bindto: "#run-duration-graph",
    title: { text: "Run Duration Over Time" }
    data: {
      columns: [duration_data],
      color: (color, d) -> return default_color
    },
    axis: {
      x: {
        type: "category",
        categories: index + 1 for split, index in gon.run.history,
        tick: {
          culling: true,
          multiline: false
        }
      },
      y: {
        label: {
          text: "Duration of Run",
          position: "outer-middle"
        },
        tick: {
          format: (d) -> moment.utc(moment.duration(d, "seconds").asMilliseconds()).format("H:mm:ss")
        }
      }
    },
    legend: { hide: true }
  })
