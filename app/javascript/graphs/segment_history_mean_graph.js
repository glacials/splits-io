import Highcharts from 'highcharts';

$(function() {
  if ($('#segment-history-graph-highchart').length === 0) {
    return;
  }

  let graph_data = [];
  gon.run.segments.forEach(function(segment) {
    let time = 0;
    if (segment.histories.length !== 0) {
      time = segment.histories.map((history) => history.duration_ms).reduce((a, b) => a + b, 0) / segment.histories.length;
      time = (time - segment.shortest_duration_ms) / 1000;
    }
    graph_data.push([segment.name, time]);
  });

  Highcharts.chart('segment-history-graph-highchart', {
    chart: {
      type: 'column'
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
