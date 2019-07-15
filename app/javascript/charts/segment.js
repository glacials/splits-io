import Highcharts from 'highcharts'
import Exporting from 'highcharts/modules/exporting'
Exporting(Highcharts)

const defaults = require('deep-defaults')

import {logoYellow, logoBlue, logoGreen} from '../colors.js'

const buildSegmentChart = function(runs, options) {
  if (document.getElementById('segment-chart') === null) {
    return
  }

  const run = runs[0]
  const timing = new URLSearchParams(window.location.search).get('timing') || run.default_timing
  const duration = `${timing}time_duration_ms`
  const shortest = `${timing}time_shortest_duration_ms`

  const pbData = []
  const meanData = []
  const finished = run[duration] > 0
  let resetCounter = run.attempts
  const resetData = []

  run.segments.forEach((segment, i) => {
    // Start PB info collection
    let time = (segment[duration] - segment[shortest]) / 1000
    if (time < 0) {
      time = 0
    }
    pbData.push([segment.name, time])

    // Start mean info collection
    time = 0
    let counter = 0
    if (segment.histories.length !== 0) {
      segment.histories.forEach((attempt) => {
        if (attempt[duration] === 0) {
          // Reject attempts that have no duration (skipped splits)
          return
        } else if (run.segments[i - 1] !== undefined) {
          const prevSegAttempt = run.segments[i - 1].histories.find((prevAttempt) => {
            // Find the previous splits attempt for this same attempt id to make sure it wasn't skipped
            return prevAttempt.attempt_number === attempt.attempt_number
          })
          if (prevSegAttempt !== undefined && prevSegAttempt[duration] === 0) {
            // Reject the first split after a series of skipped splits to prevent data pollution
            return
          }
        }

        time += attempt[duration]
        counter++
      })

      time = ((time / counter) - segment[shortest]) / 1000
    }
    meanData.push([segment.name, time])

    // Start reset info collection
    if (resetCounter - segment.histories.length > 0) {
      resetData.push([segment.name, (1 - (segment.histories.length / resetCounter)) * 100])
      resetCounter = segment.histories.length
    } else {
      resetData.push([segment.name, 0])
    }
  })

  Highcharts.chart('segment-chart', defaults(_.clone(options), {
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
    chart: {
      type: 'column',
      scrollablePlotArea: {minWidth: 75 * run.segments.length},
      zoomType: 'x'
    },
    title: {text: 'Individual Segment Stats'},
    subtitle: {text: 'Lower is Better'},
    tooltip: {
      shared: true
    },
    legend: {enabled: false},
    series: [{
      name: 'Difference of PB and Gold',
      data: pbData,
      color: logoYellow,
      tooltip: {
        pointFormat: '<span style="color:{point.color}">\u25CF</span> {series.name}: <b>{point.y:.1f}s</b><br/>'
      }
    }, {
      name: 'Difference of Average and Gold',
      data: meanData,
      color: logoBlue,
      tooltip: {
        pointFormat: '<span style="color:{point.color}">\u25CF</span> {series.name}: <b>{point.y:.1f}s</b><br/>'
      }
    }, {
      name: 'Reset Rate',
      data: resetData,
      color: logoGreen,
      tooltip: {
        pointFormat: '<span style="color:{point.color}">\u25CF</span> {series.name}: <b>{point.y:.1f}%</b><br/>'
      },
      yAxis: 1
    }],
    xAxis: {
      categories: pbData.map(function(seg) { return seg[0] }),
      crosshair: true
    },
    yAxis: [{
      title: {text: 'Possible Time Save (s)'},
      gridLineColor: 'rgba(255, 255, 255, 0.2)',
      tickColor: 'rgba(255, 255, 255, 0.2)'
    }, {
      title: {text: 'Reset Attempts Per Split (%)'},
      opposite: true,
      gridLineColor: 'rgba(255, 255, 255, 0.2)',
      tickColor: 'rgba(255, 255, 255, 0.2)'
    }]
  }))
}

export {buildSegmentChart}
