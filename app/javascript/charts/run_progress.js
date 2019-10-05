import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
import Variwide from 'highcharts/modules/variwide'
Exporting(Highcharts)
Variwide(Highcharts)

const defaults = require('deep-defaults')

const buildRunProgressChart = function(runs, options = {}) {
  if (document.getElementById('run-progress-chart') === null) {
    return
  }

  Highcharts.chart('run-progress-chart', defaults(_.clone(options), {
    exporting: {
      chartOptions: {
        legend: {
          enabled: false
        }
      }
    },
    chart: {type: 'variwide'},
    title: {text: 'Run Progress'},
    legend: {
        enabled: runs.length > 1
    },
    xAxis: {
      type: 'category'
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
        data: run.segments.map((segment) => (
          [segment.dispaly_name, parseFloat((segment.histories.length / run.attempts * 100).toFixed(1)), 20]
        )),
        name: (run.runners[0] || {name: '???'}).name,
        colorByPoint: runs.length == 1,
        tooltip: {
          pointFormatter: function() {
            return `<span style="color:${this.color}">\u25CF</span> ${this.series.name}: ${this.y}% | ${run.segments[this.index].histories.length} runs`
          }
        }
      }
    ))
  }))
}

export {buildRunProgressChart}
