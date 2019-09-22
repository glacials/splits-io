import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
import Funnel from 'highcharts/modules/funnel'
Exporting(Highcharts)
Funnel(Highcharts)

const defaults = require('deep-defaults')

const buildFunnelChart = function(runs, options = {}) {
  if (document.getElementById('funnel-chart') === null) {
    return
  }

  Highcharts.chart('funnel-chart', defaults(_.clone(options), {
    exporting: {
      chartOptions: {
        legend: {
          enabled: false
        }
      }
    },
    chart: {type: 'funnel'},
    title: {text: 'Run Progress'},
    plotOptions: {
      series: {
        dataLabels: {
          enabled: true,
          format: '<b>{point.name}</b> ({point.y:,.0f})',
          softConnector: true
        }
      }
    },
    legend: {
        enabled: false
    },
    series: runs.map((run, i) => (
      {
        center: [`${(100/(runs.length+1))*(i+1)}%`, '50%'],
        data: run.segments.map((segment) => (
          [segment.name, segment.histories.length]
        )),
        name: 'Runs reached split',
        neckWidth: runs.length === 1 ? '30%' : `${30/runs.length*0.8}%`,
        tooltip: {
          pointFormatter: function() {
            return `<span style="color:{this.point.color}">\u25CF</span> ${this.series.name}: ${this.y} | ${(this.y / run.attempts * 100).toFixed(1)}%`
          }
        },
        width: runs.length === 1 ? '80%' : `${100/(runs.length+1)*0.8}%`
      }
    ))
  }))
}

export {buildFunnelChart}
