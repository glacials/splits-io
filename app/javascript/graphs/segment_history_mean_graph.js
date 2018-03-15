import Highcharts from 'highcharts';

$(function() {
  if ($('#segment-history-graph-highchart').length === 0) {
    return;
  }

  const graph_data = [];
  gon.run.segments.forEach(function(segment) {
    let time = 0;
    if (segment.histories.length !== 0) {
      const non_zero_values = segment.histories.filter(attempt => attempt.duration_ms > 0);
      time = non_zero_values.map((history) => history.duration_ms).reduce((a, b) => a + b, 0) / non_zero_values.length;
      time = (time - segment.shortest_duration_ms) / 1000;
    }
    graph_data.push([segment.name, time]);
  });

  Highcharts.chart('segment-history-graph-highchart', {
    chart: {
      type: 'column',
      zoomType: 'x'
    },
    title: {
      text: 'Split History Mean vs Golds'
    },
    subtitle: {
      text: 'Calculated: Mean Of Each Segments History - Segment Gold'
    },
    tooltip: {
      pointFormat: 'Time Save: {point.y:.1f}s',
      shared: true
    },
    legend: {
      enabled: false
    },
    xAxis: {
      categories: graph_data.map(function(seg) { return seg[0]; }),
      crosshair: true
    },
    yAxis: {
      title: {
        text: 'Possible Time Save (s)'
      }
    },
    series: [{
      name: 'History Mean - Gold',
      data: graph_data
    }]
  });
});
