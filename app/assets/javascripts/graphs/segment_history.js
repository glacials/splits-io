$(document).on('runs#show:loaded', function() {
  if(gon.run.program !== "livesplit") {
    return
  }

  color_styles = [
    "rgba(14, 144, 210, 1)",
    "rgba(128, 87, 165, 1)",
    "rgba(94, 185, 94, 1)",
    "rgba(250, 210, 50, 1)",
    "rgba(221, 81, 76, 1)",
    "rgba(243, 123, 29, 1)"
  ]

  gon.run.segments.forEach(function(segment) {
    let chart = c3.generate({
      bindto: "#segment-graph-" + segment.id,
      title: {
        text: segment.name + " Duration over Time"
      },
      padding: {
        right: 20
      },
      data: {
        columns: [
          ['Segment Duration'].concat(segment.histories.map(function(history) {
            return history.duration_ms / 1000;
          }))
        ],
      },
      color: {
        pattern: color_styles
      },
      line: {
        connectNull: true
      },
      legend: {
        hide: true
      },
      axis: {
        x: {
          type: "category",
          categories: gon.run.histories.map(function(history) {
            return history.attempt_number;
          }),
          tick: {
            culling: true,
            multiline: false
          },
          label: {
            text: "Attempt",
            position: "outer-center"
          }
        },
        y: {
          label: {
            text: "Segment Duration",
            position: "outer-middle"
          },
          tick: {
            format: function(d) {
              return moment.utc(moment.duration(d, "seconds").asMilliseconds()).format("H:mm:ss")
            }
          }
        },
        tooltip: {
          format: {
            value: function(d) {
              return moment.utc(moment.duration(d, "seconds").asMilliseconds()).format("H:mm:ss");
            }
          }
        }
      }
    })
  });
});
