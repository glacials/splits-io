$(function () {
  if ($("#reset-graph").length === 0 || gon.run.program !== "livesplit") {
    return;
  }

  var color_styles = [
    "rgba(14, 144, 210, 1)",
    "rgba(128, 87, 165, 1)",
    "rgba(94, 185, 94, 1)",
    "rgba(250, 210, 50, 1)",
    "rgba(221, 81, 76, 1)",
    "rgba(243, 123, 29, 1)"
  ];

  let reset_counter = 0;
  let reset_data = [];

  gon.run.segments.forEach(function (segment, i) {
    let segment_total_resets = segment.histories.filter(function(h) {
      return (h.duration_ms === null || h.duration_ms === 0);
    }).length;

    // By doing this backwards we allow the loop to not need a special case for index 0
    let segment_resets = Math.abs(segment_total_resets - reset_counter);
    if (segment_resets > 0) {
      reset_data.push([segment.name, segment_resets]);
      reset_counter = segment_total_resets;
    }
  });

  c3.generate({
    bindto: "#reset-graph",
    data: {
      columns: reset_data,
      type: "donut"
    },
    color: {pattern: color_styles},
    donut: {
      title: "Resets/Split",
      label: {
        format: function (v) {
          return v;
        }
      }
    },
    tooltip: {
      format: {
        value: function (value, ratio) {
          return `${value} | ${d3.round(ratio * 100, 1)}%`;
        }
      }
    }
  })
});
