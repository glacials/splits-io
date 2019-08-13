const Highcharts = require('highcharts')
require('highcharts/modules/exporting')(Highcharts)
require('highcharts-regression')(Highcharts)

const defaults = require('deep-defaults')
const moment = require('moment')

import {logoColors} from '../colors.js'

const buildPlaytimeChart = function(runs, options = {}) {
  if (document.getElementById('playtime-chart') === null) {
    return
  }

  const timing = new URLSearchParams(window.location.search).get('timing') || runs[0].default_timing
  const duration = `${timing}time_duration_ms`

  const attemptSort = function(a, b) {
    if (a.attempt_number < b.attempt_number) {
      return -1
    }
    if (a.attempt_number > b.attempt_number) {
      return 1
    }
    return 0
  }

  const playtimeBetweenPBs = runs.map(run => {
    let lastPB = null
    let playtime = 0

    return run.histories.sort(attemptSort).filter(runAttempt => runAttempt[duration] > 0).map(runAttempt => {
      if (lastPB === null || runAttempt[duration] < lastPB[duration]) {
        lastPB = runAttempt
        return [
          run.segments.map(segment => segment.histories).flat().
          filter(segmentAttempt => segmentAttempt.attempt_number <= runAttempt.attempt_number).
          map(segmentAttempt => segmentAttempt[duration]).
          reduce((playtime, segmentAttempt) => playtime + segmentAttempt, 0),
          runAttempt[duration]
        ]
      } else {
        return null
      }
    }).filter(datum => datum != null)
  })

  Highcharts.chart('playtime-chart', defaults(_.clone(options), {
    colors: logoColors,
    chart: {
      type: 'scatter',
      zoomType: 'x'
    },
    exporting: {
      chartOptions: {
        plotOptions: {
          series: {
            dataLabels: {
              enabled: true,
              formatter: function() { return moment.duration(this.x).format('H:mm:ss') }
            }
          }
        }
      },
      fallbackToExportServer: false
    },
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
        }
      }
    },
    series: playtimeBetweenPBs.map((playtimeBetweenPBs, i) => ({
      name: runs[i].runners.length === 0 ? 'PBs' : `${runs[i].runners[0].name}'s PBs`,
      data: playtimeBetweenPBs,
      regression: playtimeBetweenPBs.length >= 2,
      regressionSettings: {
        color: logoColors[i],
        dashStyle: 'dot',
        extrapolate: playtimeBetweenPBs.length,
        name: runs[i].runners.length === 0 ? 'Predicted PBs' : `${runs[i].runners[0].name}'s Predicted PBs`,
        type: 'logarithmic'
      }
    })),
    title: {text: 'Practice Required to PB'},
    tooltip: {
      pointFormatter: function() {
        const x = moment.duration(this.x)
        const y = moment.duration(this.y)

        return `<b>Based on past data,</b> hitting a <b>${y.format('H:mm:ss')}</b> should take about <b>${Math.trunc(x.asHours())} total
          hours</b> of attempts`
      }
    },
    xAxis: {
      title: {text: 'Life Playtime'},
      labels: {formatter: function() { return `${Math.trunc(moment.duration(this.value).asHours())} h` }}
    },
    yAxis: {
      gridLineColor: 'rgba(255, 255, 255, 0.2)',
      labels: {formatter: function() { return moment.duration(this.value).format('H:mm:ss') }},
      tickColor: 'rgba(255, 255, 255, 0.2)',
      title: {text: 'PBs'}
    }
  }))
}

export {buildPlaytimeChart}
