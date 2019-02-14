import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
Exporting(Highcharts)

const build_run_duration_graph = function(run, chartOptions) {
  if (document.getElementById('run-duration-graph') === null ) {
    return
  }

  const timing = new URLSearchParams(window.location.search).get('timing') || run.default_timing
  const duration = `${timing}time_duration_ms`

  const graph_data = []
  run.histories.forEach(function(attempt) {
    let ms = attempt[duration]
    if (ms === 0) {
      ms = null
    }

    graph_data.push([attempt.attempt_number, ms])
  })
  graph_data.sort((a, b) => a[0] - b[0])

  Highcharts.chart('run-duration-graph', {
    exporting: {
      chartOptions: chartOptions,
      fallbackToExportServer: false
    },
    chart: {zoomType: 'x'},
    plotOptions: {
      series: {connectNulls: true}
    },
    title: {text: 'Run Duration over Time'},
    tooltip: {
      shared: true,
      crosshairs: true,
      pointFormatter: function() {
        const time = moment.duration(this.y).format('H:mm:ss')
        return `<span style="color:${this.color}">\u25CF</span> ${this.series.name}: <b>${time}</b><br/>`
      }
    },
    legend: {enabled: false},
    xAxis: {
      title: {text: 'Attempt Number'}
    },
    yAxis: {
      title: {text: 'Run Duration'},
      labels: {
        formatter: function() { return moment.duration(this.value).format('H:mm:ss') }
      }
    },
    series: [{
      name: 'Time',
      data: graph_data
    }]
  })
}

export {build_run_duration_graph}
