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

  fetch(`/api/v4/runs/${gon.run.id}?historic=1`, {
    headers: {accept: 'application/json'}
  }).then(function(response) {
    spinners.forEach(spinner => {
      spinner.stop()
    })
    for (const segSpinner of segSpinners) {
      segSpinner.hidden = true
    }

    if (response.ok) {
      return response.json()
    }
    throw new Error('Request for run from API failed')
  }).then(function(body) {
    const timing = new URLSearchParams(window.location.search).get('timing') || body.run.default_timing
    const duration = `${timing}time_duration_ms`

    document.getElementById('chart-spinner').hidden = true
    document.getElementById('chart-holder').hidden = false
    if (body.run.histories.length !== 0) {
      const timing = new URLSearchParams(window.location.search).get('timing') || body.run.default_timing
      const skipped = `${timing}time_skipped`

      buildRunDurationChart(body.run, chartOptions)
      buildBoxPlot(body.run, chartOptions)
      buildSegmentChart(body.run, chartOptions)
      buildResetChart(body.run, chartOptions)
      buildPlaytimeChart(body.run, chartOptions)

      body.run.segments.filter(segment => !segment.skipped).forEach(segment => {
        buildSegmentDurationChart(timing, segment, chartOptions)
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

  const segChart = Highcharts.charts.find(chart => chart.renderTo.id === `segment-duration-chart-${segId}`)
  if (!segChart) {
    return
  }

  segChart.reflow()
})

// Use debounce to collect all resize events to fire it once instead of every single time
window.addEventListener('resize', _.debounce(() => {
  Highcharts.charts.forEach((chart) => {
    const row = chart.renderTo.closest('tr')
    if (row === null) {
      return
    }

    // Use defer to allow other JS to run on the stack in between chart sizing changes
    // Without this the page will completely lock up for a bit while all charts are resized
    _.defer((size) => {
      chart.setSize(size)
    }, chart.container.closest('table').closest('.card').clientWidth)
  })
}), 250)
