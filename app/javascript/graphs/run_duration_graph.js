import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
Exporting(Highcharts)

const build_run_druation_graph = function(run) {
  if ($('#run-duration-graph-highchart').length === 0) {
    return
  }

  const url = new URL(window.location.href)
  const duration_string = `${url.searchParams.get('timing') || 'real'}time_duration_ms`

  const graph_data = []
  run.histories.forEach(function(attempt) {
    let ms = attempt[duration_string]
    if (ms === 0) {
      ms = null
    }

    graph_data.push([attempt.attempt_number, ms])
  })
  graph_data.sort((a, b) => a[0] - b[0])

  Highcharts.chart('run-duration-graph-highchart', {
    exporting: {
        chartOptions: {
            plotOptions: {
                series: {
                    dataLabels: {
                        enabled: true
                    }
                }
            }
        },
        fallbackToExportServer: false
    },
    chart: {
      zoomType: 'x'
    },
    plotOptions: {
      series: {
        connectNulls: true
      }
    },
    title: {
      text: 'Run Duration Over Time'
    },
    tooltip: {
      shared: true,
      crosshairs: true,
      pointFormatter: function() {
        const time = moment.utc(moment.duration(this.y).asMilliseconds()).format('H:mm:ss')
        return `<span style="color:${this.color}">\u25CF</span> ${this.series.name}: <b>${time}</b><br/>`
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
        formatter: function() { return moment.utc(moment.duration(this.value).asMilliseconds()).format('H:mm:ss') }
      }
    },
    series: [{
      name: 'Time',
      data: graph_data
    }]
  })
}

export {build_run_druation_graph}
