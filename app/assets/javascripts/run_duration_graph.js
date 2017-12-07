$(function() {
  if ($("#run-duration-graph").length === 0 || gon.run.program != "livesplit") {
    return;
  }

  duration_data = [];
  gon.run.history.forEach(function (attempt) {
    seconds = attempt['realtime_duration_ms'] / 1000.0;
    // The graph will show 0s but not nulls. We don't want it to show either.
    if (seconds === 0) {
      seconds = null;
    }

    duration_data[attempt['attempt_number']] = seconds;
  });

  duration_data[0] = "Run Length";
  c3.generate({
    bindto: "#run-duration-graph",
    title: {text: "Run Duration Over Time"},
    data: {columns: [duration_data]},
    subchart: {show: true},
    color: {pattern: ["rgba(14, 144, 210, 1)"]},
    line: {connectNull: true},
    axis: {
      x: {
        type: "category",
        categories: gon.run.history.map(function (segment, index) {
          return index + 1;
        }),
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
          format: function (d) {
            return moment.utc(moment.duration(d, "seconds").asMilliseconds()).format("H:mm:ss");
          }
        }
      }
    },
    legend: {hide: true}
  });
});
