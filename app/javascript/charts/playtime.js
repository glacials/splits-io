const Highcharts = require('highcharts')
require('highcharts/modules/exporting')(Highcharts)
const moment = require('moment')

require('highcharts-regression')(Highcharts)

const buildPlaytimeChart = function(run, chartOptions = {}) {
  if (document.getElementById('playtime-chart') === null) {
    return
  }

  const timing = new URLSearchParams(window.location.search).get('timing') || run.default_timing
  const duration = `${timing}time_duration_ms`

  let attemptSort = function(a, b) {
    if (a.attempt_number < b.attempt_number) {
      return -1
    }
    if (a.attempt_number > b.attempt_number) {
      return 1
    }
    return 0
  }

  let lastPB = null
  let playtime = 0
  let playtimeBetweenPBs = []
  let sortedAttempts = run.histories
  sortedAttempts.sort(attemptSort)

  sortedAttempts.filter(runAttempt => runAttempt[duration] > 0).forEach(function(runAttempt) {
    if (lastPB === null || runAttempt[duration] < lastPB[duration]) {
      playtime = run.segments.map(segment => segment.histories).flat().
        filter(segmentAttempt => segmentAttempt.attempt_number <= runAttempt.attempt_number).
        map(segmentAttempt => segmentAttempt[duration]).
        reduce((playtime, segmentAttempt) => playtime + segmentAttempt, 0),
      playtimeBetweenPBs.push([playtime, runAttempt[duration]])
      lastPB = runAttempt
    }
  })

  Highcharts.chart('playtime-chart', {
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
    chart: {
      type: 'scatter',
      zoomType: 'x'
    },
    title: {text: 'Practice Required to PB'},
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
    series: [{
      name: 'Life playtime at time of PB',
      data: playtimeBetweenPBs,
      regression: playtimeBetweenPBs.length >= 2,
      regressionSettings: {
        name: 'Prediction',
        type: 'logarithmic',
        color: 'rgba(250, 200, 50, 1)',
        dashStyle: 'dot',
        extrapolate: playtimeBetweenPBs.length
      }
    }],
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
