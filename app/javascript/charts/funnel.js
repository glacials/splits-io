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
        },
        center: ['40%', '50%'],
        neckWidth: '30%',
        neckHeight: '25%',
        width: '80%'
      }
    },
    legend: {
        enabled: false
    },
    series: runs.map((run) => (
      {
        name: 'Runs reached split',
        data: run.segments.map((segment) => (
          [segment.name, segment.histories.length]
        )),
        tooltip: {
          pointFormatter: function() {
            return `<span style="color:{this.point.color}">\u25CF</span> ${this.series.name}: ${this.y} | ${(this.y / run.attempts * 100).toFixed(1)}%`
          }
        }
      }
    ))
  }))
}

export {buildFunnelChart}
