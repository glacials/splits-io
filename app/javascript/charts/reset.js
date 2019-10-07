import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
Exporting(Highcharts)

const defaults = require('deep-defaults')

const buildResetChart = function(runs, options = {}) {
  if (document.getElementById('reset-chart') === null) {
    return
  }

  Highcharts.chart('reset-chart', defaults(_.clone(options), {
    exporting: {
      chartOptions: {
        legend: {
          enabled: false
        }
      }
    },
    chart: {type: 'pie'},
    title: {text: 'Resets Per Split'},
    tooltip: {
      pointFormat: '<span style="color:{point.color}">\u25CF</span> {series.name}: {point.y} | {point.percentage:.1f}%',
    },
    plotOptions: {
      pie: {
        showInLegend: true,
        events: {
          afterAnimate: function() {
            let chart = this.chart
            let legend = chart.legend
            let tooltip = this.chart.tooltip
            for (let item of legend.getAllItems()) {
              if (!item.legendItem) {
                // exporting with no legend
                return
              }

              item.legendItem.on('mouseover', function (e) {
                let data = item.series.data[item.index]
                tooltip.refresh(data)
              }).on('mouseout', function (e) {
                tooltip.hide()
              })
            }
          }
        }
      }
    },
    yAxis: {
      title: {text: 'Resets'}
    },
    series: runs.map((run, i) => {
      let attemptsSoFar = run.attempts

      return {
        center: [`${(100/(runs.length+1))*(i+1)}%`, '50%'],
        data: run.segments.map((segment, i) => {
          const attemptsReachedSegment = attemptsSoFar
          attemptsSoFar = segment.histories.length

          return [segment.display_name, attemptsReachedSegment - segment.histories.length]
        }).filter(datum => datum[1] > 0),
        innerSize: '50%',
        linkedTo: ':previous',
        name: (run.runners[0] || {name: '???'}).name
      }
    })
  }))
}

export {buildResetChart}
