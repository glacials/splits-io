import {build_pb_graph} from "graphs/pb_graph.js"
import {build_segment_history_mean_graph} from "graphs/segment_history_mean_graph.js"
import {build_run_druation_graph} from "graphs/run_duration_graph.js"
import {build_segment_duration_graph} from "graphs/segment_duration_graph.js"
import {build_reset_graph} from "graphs/reset_graph.js"

$(function() {
  const $body = $('body');
  if ($body.data('action') !== 'index' && $body.data('controller') !== 'stats') {
    return
  }

  fetch(`/api/v4/runs/${gon.run.id}?historic=1`, {
    headers: {
      accept: 'application/json'
    }
  })
  .then(function(response) {
    if (response.ok) {
      return response.json()
    }
    throw new Error('Request for run from api failed')
  })
  .then(function(run) {
    build_pb_graph(run.run)
    if (run.run.program === 'livesplit') {
      build_segment_history_mean_graph(run.run)
      build_run_druation_graph(run.run)
      build_segment_duration_graph(run.run)
      build_reset_graph(run.run)
    }
  })
  .catch(error => console.error(error))
})
