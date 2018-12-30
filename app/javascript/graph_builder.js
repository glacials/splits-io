import {build_run_duration_graph} from "graphs/run_duration_graph.js"
import {build_playtime_graph} from "graphs/playtime_graph.js"
import {buildSegmentGraphs} from "graphs/segment_graphs.js"

document.addEventListener('turbolinks:load', function() {
  if (document.getElementById('graph-holder') === null) {
    return
  }

  fetch(`/api/v4/runs/${gon.run.id}?historic=1`, {
    headers: {accept: 'application/json'}
  }).then(function(response) {
    if (response.ok) {
      return response.json()
    }
    throw new Error('Request for run from API failed')
  }).then(function(run) {
    document.getElementById('graph-spinner').hidden = true
    document.getElementById('graph-holder').hidden = false
    if (run.run.histories.length !== 0) {
      build_run_duration_graph(run.run)
      buildSegmentGraphs(run.run)
      build_playtime_graph(run.run)
    }
  }).catch(function(error) {
    document.getElementById('graph-spinner').style.display = 'none'
    document.getElementById('graph-alert').textContent = 'Error loading graphs: ' + error
    document.getElementById('graph-alert').hidden = false

    throw error
  })
})
