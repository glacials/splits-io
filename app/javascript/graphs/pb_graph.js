import Highcharts from 'highcharts';

$(function() {
  if ($('#pb-graph-highchart').length === 0) {
    return;
  }

  let graph_data = [];
  gon.run.segments.forEach(function(segment, i) {
    let time = (segment.duration_ms - segment.shortest_duration_ms) / 1000;
    if (time < 0) {
      time = 0;
    }

    graph_data.push([segment.name, time]);
  });

  Highcharts.chart('pb-graph-highchart', {
    chart: {
      type: 'column',
      zoomType: 'x'
    },
    title: {
      text: 'PB vs Golds'
    },
    subtitle: {
      text: 'Calculated: PB - Gold'
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
      name: 'PB - Gold',
      data: graph_data
    }]
  });
});
