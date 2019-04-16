const Highcharts = require('highcharts')
require('highcharts/modules/exporting')(Highcharts)
const moment = require('moment')

const buildRunDurationChart = function(run, chartOptions) {
  if (document.getElementById('run-duration-chart') === null ) {
    return
  }

  const timing = new URLSearchParams(window.location.search).get('timing') || run.default_timing
  const duration = `${timing}time_duration_ms`

  return Highcharts.chart('run-duration-chart', {
    exporting: {
      chartOptions: chartOptions,
      fallbackToExportServer: false
    },
    chart: {
      type: 'spline',
      zoomType: 'x'
    },
    plotOptions: {
      series: {
        connectNulls: true,
        halo: null
      },
      spline: {
        marker: {enabled: false}
      }
    },
    series: [{
      name: 'Run Time',
      data: run.histories.map(attempt => {
        return [attempt.attempt_number, attempt[duration] === 0 ? null : attempt[duration]]
      }).sort((a, b) => a[0] - b[0])
    }],
    title: {text: 'Run Duration over Time'},
    tooltip: {
      shared: true,
      crosshairs: true,
      pointFormatter: function() {
        const time = moment.duration(this.y).format('H:mm:ss')
        return `<span style="color:${this.color}">\u25CF</span> ${this.series.name}: <b>${time}</b><br/>`
      }
    },
    xAxis: {
      title: {text: 'Attempt Number'}
    },
    yAxis: {
      gridLineColor: 'rgba(255, 255, 255, 0.2)',
      labels: {formatter: function() { return moment.duration(this.value).format('H:mm:ss') }},
      tickColor: 'rgba(255, 255, 255, 0.2)',
      title: {text: 'Run Duration'}
    }
  })
}

export {buildRunDurationChart}
