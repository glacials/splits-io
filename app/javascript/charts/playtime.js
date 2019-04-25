const Highcharts = require('highcharts')
require('highcharts/modules/exporting')(Highcharts)
const moment = require('moment')
import {logoYellow, logoBlue, logoColors} from '../colors.js'

require('highcharts-regression')(Highcharts)

const buildPlaytimeChart = function(runs, chartOptions = {}) {
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

  Highcharts.chart('playtime-chart', {
    colors: logoColors,
    chart: {
      type: 'scatter',
      zoomType: 'x'
    },
    exporting: {
      chartOptions: Object.assign(chartOptions, {
        plotOptions: {
          series: {
            dataLabels: {enabled: true}
          },
          line: {
            dataLabels: {
              enabled: true,
              formatter: () => this.x
            }
          }
        }
      }),
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
          pointFormatter: function() {
            const x = Math.trunc(moment.duration(this.x).asHours())
            const y = moment.duration(this.y).format('H:mm:ss')
            const xdiff = moment.duration(this.x - playtime)

            if (this.y >= lastPB[duration]) {
              return `Splits I/O would have predicted <b>${x} hours</b> of practice to get a <b>${y}</b>`
            }
            if (xdiff < 0) {
              return `<b>Too soon to say</b> 🤷`
            }

            return `<b>Prediction:</b> PB should hit <b>${y}</b> after about <b>${Math.trunc(xdiff.asHours())} more
              hours</b> of attempts<br />(about <b>${Math.trunc(xdiff.asMilliseconds() / lastPB[duration])}
              </b>full attempts' worth)`
          }
        }
      }
    },
    series: playtimeBetweenPBs.map((playtimeBetweenPBs, i) => ({
      name: `${runs[i].runners[0].name}'s PBs`,
      data: playtimeBetweenPBs,
      regression: playtimeBetweenPBs.length >= 2,
      regressionSettings: {
        name: `${runs[i].runners[0].name}'s Projected PBs`,
        type: 'logarithmic',
        color: logoColors[i],
        dashStyle: 'dot',
        extrapolate: playtimeBetweenPBs.length
      }
    })),
    title: {text: 'Practice Required to PB'},
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
  })
}

export {buildPlaytimeChart}
