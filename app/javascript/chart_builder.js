import {buildSegmentDurationChart} from "charts/segment_duration.js"
import {buildRunDurationChart} from "charts/run_duration.js"
import {buildSegmentChart} from "charts/segment.js"
import {buildPlaytimeChart} from "charts/playtime.js"
import {buildResetChart} from "charts/reset.js"
import {buildBoxPlot} from "charts/box_plot.js"
import {chartOptions} from "consts.js"
import {createSpinner} from 'spinner.js'
import Highcharts from 'highcharts'
import _ from 'underscore'

document.addEventListener('turbolinks:load', function() {
  if (document.getElementById('chart-holder') === null) {
    return
  }

  const segSpinners = document.getElementsByClassName('segment-spinner')
  const spinners = []
  for (const segSpinner of segSpinners) {
    const spinner = createSpinner({
      position: 'relative'
    })
    spinner.spin(segSpinner)
    spinners.push(spinner)
  }
  const runs = []

  runs.push(fetch(`/api/v4/runs/${gon.run.id}?historic=1`, {
    headers: {accept: 'application/json'}
  }))

  if (gon.compare_runs !== undefined) {
    gon.compare_runs.forEach(run => runs.push(fetch(`/api/v4/runs/${run.id}?historic=1`, {
      headers: {accept: 'application/json'}
    })))
  }

  Promise.all(runs).then(function(responses) {
    spinners.forEach(spinner => {
      spinner.stop()
    })
    for (const segSpinner of segSpinners) {
      segSpinner.hidden = true
    }

    if (responses.every(response => response.ok)) {
      return Promise.all(responses.map(response => response.json()))
    }
    throw new Error('Request for run from API failed')
  }).then(function(bodies) {
    let runs = bodies.map(body => body.run)
    const timing = new URLSearchParams(window.location.search).get('timing') || runs[0].default_timing

    document.getElementById('chart-spinner').hidden = true
    document.getElementById('chart-holder').hidden = false
    if (runs[0].histories.length !== 0) {
      const skipped = `${timing}time_skipped`
      const duration = `${timing}time_duration_ms`
      runs = runs.map((run) => (
        {
          ...run,
          segments: run.segments.map((segment, i) => (
            {
              ...segment,
              filteredHistories: segment.histories.filter((attempt) => {
                if (attempt[duration] === 0) {
                  return false
                }
                if (run.segments[i - 1] !== undefined) {
                  const prevSegAttempt = run.segments[i - 1].histories.find((prevAttempt) => {
                    // Find the previous splits attempt for this same attempt id to make sure it wasn't skipped
                    return prevAttempt.attempt_number === attempt.attempt_number
                  })
                  if (prevSegAttempt !== undefined && prevSegAttempt[duration] === 0) {
                    // Reject the first split after a series of skipped splits to prevent data pollution
                    return false
                  }
                }
                return true
              })
            }
          ))
        }
      ))

      buildRunDurationChart(runs, chartOptions)
      buildBoxPlot(runs, chartOptions)
      buildSegmentChart(runs, chartOptions)
      buildResetChart(runs, chartOptions)
      buildPlaytimeChart(runs, chartOptions)

      runs[0].segments.filter(segment => !segment.skipped).forEach((segment, i) => {
        buildSegmentDurationChart(
          timing,
          runs,
          runs.map(run => run.segments[i]).filter(segment => segment !== undefined),
          chartOptions
        )
      })
    }
  }).catch(function(error) {
    for (const segChartAlert of document.getElementsByClassName('segment-chart-alert')) {
      segChartAlert.textContent = `Error loading charts: ${error}`
      segChartAlert.hidden = false
    }
    document.getElementById('chart-spinner').style.display = 'none'
    document.getElementById('chart-alert').textContent = `Error loading charts: ${error}`
    document.getElementById('chart-alert').hidden = false

    throw error
  })
})

document.addEventListener('click', event => {
  const toggler = event.target.closest('.segment-duration-chart-toggler')
  if (!toggler) {
    return
  }

  const segId = toggler.dataset.segment
  const row = document.querySelector(`.segment-duration-chart[data-segment="${segId}"]`).closest('tr')
  row.hidden = !row.hidden

  if (row.hidden) {
    return
  }

  // With Turbolinks, Highcharts can leave behind old charts that are from previous pageloads. If the user loaded the
  // same page twice, it's possible there are multiple charts rendered to elements with the same IDs, even if some are
  // not in the DOM.
  const segCharts = Highcharts.charts.filter(chart => chart.renderTo.id === `segment-duration-chart-${segId}`)
  segCharts.forEach(chart => chart.reflow())
})

window.addEventListener('resize', () => {
  _.debounce(() => {
    Highcharts.charts.forEach((chart, i) => {
      if (chart === undefined) {
        return
      }

      const row = chart.renderTo.closest('tr')
      if (row === null) {
        return
      }

      // We use setTimeout below for two reasons:
      // 1. To defer the reflow so other JS can run on the stack in between chart sizing changes, to avoid blocking the UI
      // 2. To stagger the chart resizes from one another, so they don't all fire at once and stutter each other
      window.setTimeout(() => {
        chart.setSize(chart.container.closest('table').closest('.card').clientWidth)
        chart.reflow()
      }, 0)
    })
  }, 1000)()
})

