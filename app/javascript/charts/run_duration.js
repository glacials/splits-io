const Highcharts = require('highcharts')
require('highcharts/modules/exporting')(Highcharts)

const defaults = require('deep-defaults')
const moment = require('moment')

import {logoColors} from '../colors.js'

const buildRunDurationChart = function(runs, options = {}) {
  if (document.getElementById('run-duration-chart') === null ) {
    return
  }

  const timing = new URLSearchParams(window.location.search).get('timing') || runs[0].default_timing
  const duration = `${timing}time_duration_ms`

  return Highcharts.chart('run-duration-chart', defaults(_.clone(options), {
    chart: {
      type: 'spline',
      zoomType: 'x'
    },
    colors: logoColors,
    plotOptions: {
      series: {
        connectNulls: true,
        halo: null
      },
      spline: {
        marker: {enabled: false}
      }
    },
    series: runs.map(run => ({
      name: (run.runners[0] || {name: '???'}).name,
      data: run.histories.map(attempt => {
        return [attempt.attempt_number, attempt[duration] === 0 ? null : attempt[duration]]
      }).sort((a, b) => a[0] - b[0]),
      dataLabels: {
        formatter: function() { return moment.duration(this.y).format('H:mm:ss') }
      }
    })),
    title: {text: 'Run Duration over Time'},
    tooltip: {
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
  }))
}

export {buildRunDurationChart}
