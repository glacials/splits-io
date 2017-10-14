$ ->
  if $("#run-duration-graph").length is 0 or gon.run.program isnt "livesplit"
    return

  color_styles = ["rgba(14, 144, 210, 1)"]

  duration_data = []
  gon.run.history.forEach (attempt) ->
    duration_data[attempt['attempt_number']] = attempt['realtime_duration_ms'] / 1000.0

  duration_data[0] = "Run Length"
  c3.generate({
    bindto: "#run-duration-graph",
    title: { text: "Run Duration over Time" }
    data: {
      columns: [duration_data],
    },
    subchart: {
      show: true
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
        categories: index + 1 for split, index in gon.run.history,
        tick: {
          culling: true,
          multiline: false
        },
        label: {
          text: "Run Number",
          position: "outer-center"
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
