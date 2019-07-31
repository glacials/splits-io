const Highcharts = require('highcharts')
require('highcharts/modules/exporting')(Highcharts)

const defaults = require('deep-defaults')
const moment = require('moment')

import {logoColors, logoYellow, logoGreen, logoBlue} from '../colors.js'

const buildSegmentDurationChart = function(timing, runs, segments, options = {}) {
  if (document.getElementById(`segment-duration-chart-${segments[0].id}`) === null) {
    return
  }

  const duration = `${timing}time_duration_ms`

  Highcharts.chart(`segment-duration-chart-${segments[0].id}`, defaults(_.clone(options), {
    exporting: {enabled: false},
    chart: {
      borderRadius: 0,
      borderWidth: 0,
      plotBorderWidth: 0,
      type: 'spline',
      zoomType: 'xy'
    },
    colors: logoColors,
    plotOptions: {
      series: {connectNulls: true},
      spline: {
        marker: {enabled: false}
      }
    },
    series: segments.map((segment, i) => ({
      name: `${(runs[i].runners[0] || {name: '???'}).name}'s ${segment.name}`,
      data: segment.histories.filter(attempt => attempt[duration] > 0).map(attempt => {
        return [`Attempt #${attempt.attempt_number}`, attempt[duration]]
      }),
      pointStart: 1
    })),
    title: {text: undefined},
    tooltip: {
      shared: true,
      crosshairs: true,
      pointFormatter: function() {
        let time = moment.duration(this.y).format('H:mm:ss')
        return `<span style="color: #fff">\u25CF</span> ${this.series.name}: <b>${time}</b><br/>`
      }
    },
    xAxis: {
      allowDecimals: false,
      lineColor: '#fff',
      title: {text: 'Attempt Number'}
    },
    yAxis: {
      gridLineColor: 'rgba(255, 255, 255, 0.2)',
      labels: {formatter: function() { return moment.duration(this.value).format('H:mm:ss') }},
      tickColor: 'rgba(255, 255, 255, 0.2)',
      title: {text: 'Duration of Segment'}
    }
  }))
}

export {buildSegmentDurationChart}
