import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
Exporting(Highcharts)

const defaults = require('deep-defaults')

const buildRunProgressLineChart = function(runs, options = {}) {
  if (document.getElementById('run-progress-line-chart') === null) {
    return
  }

  Highcharts.chart('run-progress-line-chart', defaults(_.clone(options), {
    exporting: {
      chartOptions: {
        legend: {
          enabled: false
        }
      }
    },
    chart: {type: 'line'},
    title: {text: 'Run Progress'},
    legend: {
        enabled: false
    },
    xAxis: {
      categories: runs[0].segments.map(segment => segment.name)
    },
    yAxis: {
      max: 100,
      min: 0,
      title: {
        text: 'Percent of Runs Reached Split'
      }
    },
    series: runs.map((run, i) => (
      {
        data: run.segments.map(segment => parseFloat((segment.histories.length / run.attempts * 100).toFixed(1))),
        name: (run.runners[0] || {name: '???'}).name,
        // dataLabels: {
        //   formatter: function() { return moment.duration(this.y).format('H:mm:ss') }
        // },

        // tooltip: {
        //   pointFormatter: function() {
        //     return `<span style="color:${this.point.color}">\u25CF</span> ${this.series.name}: ${this.y}%`
        //   }
        // }
      }
    ))
  }))
}

export {buildRunProgressLineChart}
