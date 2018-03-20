import {build_pb_graph} from "graphs/pb_graph.js"
import {build_segment_history_mean_graph} from "graphs/segment_history_mean_graph.js"
import {build_run_druation_graph} from "graphs/run_duration_graph.js"
import {build_segment_duration_graph} from "graphs/segment_duration_graph.js"
import {build_reset_graph} from "graphs/reset_graph.js"
import {Spinner} from 'spin.js'

$(function() {
  const $graph_holder = $('#graph-holder');
  if ($graph_holder.length === 0) {
    return
  }

  const $panel = $('<div />').addClass('panel panel-default').append($('<div />').addClass('panel-body'))
  const $info_panel = panel_builder($panel, 'graph-info')
  $info_panel.prepend($('<div />').addClass('panel-title'))
  $info_panel.find('.panel-title').append($('<h1 />').addClass('center').text('Loading graph data'))
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
  $graph_holder.append($info_panel)
  spinner.spin(document.getElementById('graph-holder').getElementsByClassName('panel-body')[0])

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
    spinner.stop()
    $graph_holder.empty()
    $graph_holder.append(panel_builder($panel, 'pb-graph-highchart'))
    build_pb_graph(run.run)
    if (run.run.program === 'livesplit') {
      $graph_holder.append(panel_builder($panel, 'segment-history-graph-highchart'))
      build_segment_history_mean_graph(run.run)
      $graph_holder.append(panel_builder($panel, 'run-duration-graph-highchart'))
      build_run_druation_graph(run.run)
      $graph_holder.append(panel_builder($panel, 'segment-duration-graph-highchart'))
      build_segment_duration_graph(run.run)
      $graph_holder.append(panel_builder($panel, 'reset-graph-highchart'))
      build_reset_graph(run.run)
    }
  })
  .catch(function(error) {
    spinner.stop()
    $graph_holder.find('.panel-title').find('h1').text('Error retrieving data for graphs')
  })
})

const panel_builder = function($panel, id_string) {
  const $panel_clone = $panel.clone()
  $panel_clone.find('.panel-body').append($('<div />').prop('id', id_string))
  return $panel_clone
}
