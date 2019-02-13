import {build_run_duration_graph} from "graphs/run_duration_graph.js"
import {build_reset_graph} from "graphs/reset_graph.js"
import {build_playtime_graph} from "graphs/playtime_graph.js"
import {buildSegmentGraphs} from "graphs/segment_graphs.js"
import {build_segment_graph} from "graphs/segment_duration_graph.js"
import {example_run} from "example_run.js"
import {example_segment} from "example_run.js"

document.addEventListener('turbolinks:load', () => {
  if (window.pathname !== '/' || gon.user !== null) {
    return
  }
  gon.run = {default_timing: 'real', id: 'example'}

  build_run_duration_graph(example_run,     {}, {title: {text: ''}})
  build_reset_graph(       example_run,     {}, {title: {text: ''}})
  build_playtime_graph(    example_run,     {}, {title: {text: ''}})
  buildSegmentGraphs(      example_run,     {}, {title: {text: ''}})
  build_segment_graph(     example_segment, {}, {title: {text: ''}})

  const aboveTheFold = document.getElementById('above-the-fold')
  const belowTheFold = document.getElementById('below-the-fold')

  aboveTheFold.style['min-height'] = `${window.innerHeight}px`
  belowTheFold.style.visibility = 'visible'

  document.addEventListener('click', event => {
    if (event.target.matches('#scroll') || event.target.parentElement.matches('#scroll')) {
      belowTheFold.scrollIntoView({block: 'start', behavior: 'smooth'})
    }
  })
})
