import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
Exporting(Highcharts)

const build_reset_graph = function(run) {
  if (document.getElementById('reset-graph') === null) {
    return
  }

  let reset_counter = run.attempts
  let reset_data = []

  run.segments.forEach(function(segment, i) {
    if (reset_counter - segment.histories.length > 0) {
      reset_data.push([segment.name, reset_counter - segment.histories.length])
      reset_counter = segment.histories.length
    }
  })

  Highcharts.chart('reset-graph', {
    exporting: {
      chartOptions: {
        plotOptions: {
          series: {
            dataLabels: {enabled: true}
          }
        }
      },
      fallbackToExportServer: false
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
            for (let item of legend.allItems) {
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
    series: [{
      name: 'Resets',
      data: reset_data,
      innerSize: '50%'
    }]
  })
}

export {build_reset_graph}
