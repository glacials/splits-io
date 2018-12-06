import {build_pb_graph} from "graphs/pb_graph.js"
import {build_run_duration_graph} from "graphs/run_duration_graph.js"
import {build_reset_graph} from "graphs/reset_graph.js"
import {build_segment_history_mean_graph} from "graphs/segment_history_mean_graph.js"
import {build_playtime_graph} from "graphs/playtime_graph.js"

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
    build_pb_graph(run.run)
    if (run.run.program === 'livesplit') {
      build_run_duration_graph(run.run)
      build_reset_graph(run.run)
      build_segment_history_mean_graph(run.run)
      build_playtime_graph(run.run)
    }
  }).catch(function(error) {
    document.getElementById('graph-spinner').style.display = 'none'
    document.getElementById('graph-alert').textContent = 'Error loading graphs: ' + error
    document.getElementById('graph-alert').hidden = false

    throw error
  })
})
