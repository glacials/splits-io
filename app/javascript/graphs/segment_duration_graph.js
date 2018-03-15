import Highcharts from 'highcharts';

$(function() {
  if ($('#segment-duration-graph-highchart').length === 0) {
    return;
  }

  let graph_data = [];
  gon.run.segments.forEach(function(segment) {
    const non_zero_values = segment.histories.filter((attempt) => attempt.duration_ms > 0);
    graph_data.push({
      name: segment.name,
      data: non_zero_values.map(function(hist) { return hist.duration_ms; }),
      visible: false,
      pointStart: 1
    });
  });
  graph_data[0].visible = true;

  Highcharts.chart('segment-duration-graph-highchart', {
    chart: {
      zoomType: 'x'
    },
    title: {
      text: 'Segment Durations Over Time'
    },
    tooltip: {
      shared: true,
      crosshairs: true,
      pointFormatter: function() {
        let time = moment.utc(moment.duration(this.y).asMilliseconds()).format('H:mm:ss');
        return `<span style="color:${this.color}">\u25CF</span> ${this.series.name}: <b>${time}</b><br/>`;
      }
    },
    xAxis: {
      title: {
        text: 'Attempt Number'
      }
    },
    yAxis: {
      title: {
        text: 'Duration of History'
      },
      labels: {
        formatter: function() { return moment.utc(moment.duration(this.value).asMilliseconds()).format('H:mm:ss'); }
      }
    },
    series: graph_data
  });
});
