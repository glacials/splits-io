import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
Exporting(Highcharts)

import 'vendor/highcharts-regression'

const build_playtime_graph = function(run) {
  if (document.getElementById('playtime-graph') === null) {
    return
  }

  let last_pb = null
  let cumulative_playtime = 0
  let playtime_between_pbs = []

  let sorted_histories = run.histories
  sorted_histories.sort(function(a, b) {
    if (a.attempt_number < b.attempt_number) {
      return -1
    }
    if (a.attempt_number > b.attempt_number) {
      return 1
    }
    return 0
  })

  sorted_histories.forEach(function(history) {
    if (history.realtime_duration_ms <= 0) {
      return
    }
    cumulative_playtime += history.realtime_duration_ms
    if (last_pb === null || history.realtime_duration_ms < last_pb.realtime_duration_ms) {
      playtime_between_pbs.push([cumulative_playtime, history.realtime_duration_ms])
      last_pb = history
    }
  })

  Highcharts.chart('playtime-graph', {
    exporting: {
      chartOptions: {
        plotOptions: {
          series: {
            dataLabels: {enabled: true}
          },
          line: {
            dataLabels: {
              enabled: true,
              formatter: () => this.x
            }
          }
        }
      },
      fallbackToExportServer: false
    },
    chart: {
      type: 'scatter',
      zoomType: 'x'
    },
    title: {text: 'Practice Required to PB'},
    plotOptions: {
      series: {connectNulls: true},
      scatter: {
        tooltip: {
          headerFormat: '',
          shared: true,
          pointFormatter: function() {
            const x = Math.trunc(moment.duration(this.x).asHours())
            const y = moment.duration(this.y).format('H:mm:ss')
            return `Getting a <b>${y}</b> took <b>${x} hours</b> of attempts`
          }
        }
      },
      spline: {
        tooltip: {
          headerFormat: '',
          shared: true,
          pointFormatter: function() {
            const x = Math.trunc(moment.duration(this.x).asHours())
            const y = moment.duration(this.y).format('H:mm:ss')
            const xdiff = moment.duration(this.x - cumulative_playtime)

            if (this.y >= last_pb.realtime_duration_ms) {
              return `Regression analysis says <b>${x} hours</b> of attempts should yield a <b>${y}</b>`
            }
            if (xdiff < 0) {
              return `<b>Too soon to say</b> 🤷`
            }

            return `<b>Prediction:</b> PB should hit <b>${y}</b> after about <b>${Math.trunc(xdiff.asHours())} more
              hours</b> of attempts<br />(about <b>${Math.trunc(xdiff.asMilliseconds() / last_pb.realtime_duration_ms)}
              </b>full attempts' worth)`
          }
        }
      }
    },
    xAxis: {
      title: {text: 'Life Playtime'},
      labels: {formatter: function() { return `${Math.trunc(moment.duration(this.value).asHours())} h` }}
    },
    yAxis: {
      title: {text: 'PBs'},
      labels: {formatter: function() { return moment.duration(this.value).format('H:mm:ss') }}
    },
    series: [{
      name: 'Life playtime at time of PB',
      data: playtime_between_pbs,
      regression: true,
      regressionSettings: {
        name: 'Prediction',
        type: 'logarithmic',
        color: 'rgba(250, 200, 50, 1)',
        dashStyle: 'dot',
        extrapolate: playtime_between_pbs.length
      }
    }]
  })
}

export {build_playtime_graph}
