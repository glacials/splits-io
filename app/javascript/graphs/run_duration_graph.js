import Highcharts from 'highcharts';

$(function() {
  if ($('#run-duration-graph-highchart').length === 0) {
    return;
  }

  let graph_data = [];
  gon.run.history.forEach(function(attempt) {
    let ms = attempt.realtime_duration_ms;
    if (ms === 0) {
      ms = null;
    }

    graph_data.push([attempt.attempt_number, ms]);
  });
  graph_data.sort((a, b) => a[0] - b[0]);

  Highcharts.chart('run-duration-graph-highchart', {
    chart: {
      zoomType: 'x'
    },
    title: {
      text: 'Run Duration Over Time'
    },
    tooltip: {
      shared: true,
      crosshairs: true,
      pointFormatter: function() {
        let time = moment.utc(moment.duration(this.y).asMilliseconds()).format('H:mm:ss');
        return `<span style="color:${this.color}">\u25CF</span> ${this.series.name}: <b>${time}</b><br/>`;
      }
    },
    legend: {
      enabled: false
    },
    xAxis: {
      title: {
        text: 'Attempt Number'
      }
    },
    yAxis: {
      title: {
        text: 'Run Duration'
      },
      labels: {
        formatter: function() { return moment.utc(moment.duration(this.value).asMilliseconds()).format('H:mm:ss'); }
      }
    },
    series: [{
      name: 'Time',
      connectNulls: true,
      data: graph_data
    }]
  });
});
