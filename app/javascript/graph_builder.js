import {build_segment_graph} from "graphs/segment_duration_graph.js"
import {build_run_duration_graph} from "graphs/run_duration_graph.js"
import {buildSegmentGraphs} from "graphs/segment_graphs.js"
import {build_playtime_graph} from "graphs/playtime_graph.js"
import {build_reset_graph} from "graphs/reset_graph.js"
import {chartOptions} from "consts.js"
import {Spinner} from 'spin.js'

document.addEventListener('turbolinks:load', function() {
  if (document.getElementById('graph-holder') === null) {
    return
  }

  const spinners = []
  for (const segSpinner of document.getElementsByClassName('segment-spinner')) {
    const spinner = new Spinner({
      lines: 3,
      length: 15,
      width: 1,
      radius: 0,
      corners: 1,
      rotate: 90,
      direction: 1,
      color: '#FFFFFF',
      speed: 0.5,
      trail: 30,
      shadow: false,
      hwaccel: true,
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

    if (response.ok) {
      return response.json()
    }
    throw new Error('Request for run from API failed')
  }).then(function(run) {
    document.getElementById('graph-spinner').hidden = true
    document.getElementById('graph-holder').hidden = false
    if (run.run.histories.length !== 0) {
      run.run.segments.forEach(segment => {
        build_segment_graph(segment, chartOptions)
      })
      build_run_duration_graph(run.run, chartOptions)
      buildSegmentGraphs(run.run, chartOptions)
      build_reset_graph(run.run, chartOptions)
      build_playtime_graph(run.run, chartOptions)
    }
  }).catch(function(error) {
    for (const segGraphAlert of document.getElementsByClassName('segment-graph-alert')) {
      segGraphAlert.textContent = `Error loading graphs: ${error}`
      segGraphAlert.hidden = false
    }
    document.getElementById('graph-spinner').style.display = 'none'
    document.getElementById('graph-alert').textContent = `Error loading graphs: ${error}`
    document.getElementById('graph-alert').hidden = false

    throw error
  })
})

document.addEventListener('click', event => {
  if (event.target.matches('.segment-graph-toggler')) {
    event.preventDefault()
    const row = document.querySelector(`.segment-graph-holder[data-segment="${toggler.dataset.segment}"]`)
                .closest('tr')
    row.hidden = !row.hidden
  }
})
