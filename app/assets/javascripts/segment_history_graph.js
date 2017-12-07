$(function () {
  if ($("#segment-duration-graph").length === 0 || gon.run.program != "livesplit") {
    return;
  }

  color_styles = [
    "rgba(14, 144, 210, 1)",
    "rgba(128, 87, 165, 1)",
    "rgba(94, 185, 94, 1)",
    "rgba(250, 210, 50, 1)",
    "rgba(221, 81, 76, 1)",
    "rgba(243, 123, 29, 1)"
  ];

  seg_histories = [];
  hidden_data = [];
  first_non_null_attempt = Infinity;

  gon.run.segments.forEach(function (segment, i) {
    non_null_time_inserted = false;
    attempt_durations = [];
    segment.histories.forEach(function (attempt, j) {
      if (non_null_time_inserted || attempt.duration_ms != null) {
        non_null_time_inserted = true;

        seconds = attempt.duration_ms / 1000;
        // The graph will show 0s but not nulls. We don't want it to show either.
        if (seconds === 0) {
          seconds = null;
        }

        attempt_durations.push(seconds);

        if (j < first_non_null_attempt) {
          first_non_null_attempt = j;
        }
      } else {
        attempt_durations.push(null);
      }
    });

    seg_histories.push(JSON.parse(JSON.stringify(attempt_durations)));
    seg_histories[i].unshift(segment.name);

    if (seg_histories.length > 1) {
      hidden_data.push(segment.name);
    }
  });

  c3.generate({
    bindto: "#segment-duration-graph",
    title: {
      text: "Segment Durations Over Time (choose segments below)"
    },
    data: {
      columns: seg_histories,
      hide: hidden_data
    },
    subchart: {show: true},
    size: {
      height: 320 * ((gon.run.segments.length / 60) + 1)
    },
    color: {pattern: color_styles},
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
          format: function (d) {
            return moment.utc(moment.duration(d, "seconds").asMilliseconds()).format("H:mm:ss")
          }
        }
      }
    }
  })
});
