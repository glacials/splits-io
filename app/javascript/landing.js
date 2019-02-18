import {build_run_duration_graph} from "graphs/run_duration_graph.js"
import {build_reset_graph} from "graphs/reset_graph.js"
import {build_playtime_graph} from "graphs/playtime_graph.js"
import {buildSegmentGraphs} from "graphs/segment_graphs.js"
import {build_segment_graph} from "graphs/segment_duration_graph.js"
import {example_run} from "example_run.js"
import {example_segment} from "example_run.js"

document.addEventListener('turbolinks:load', () => {
  if (window.location.pathname !== '/' || gon.user !== null) {
    return
  }

  build_run_duration_graph(   example_run,     {})
  build_reset_graph(          example_run,     {})
  build_playtime_graph(       example_run,     {})
  buildSegmentGraphs(         example_run,     {})
  build_segment_graph('real', example_segment, {})

  const aboveTheFold = document.getElementById('above-the-fold')
  const belowTheFold = document.getElementById('below-the-fold')

  aboveTheFold.style['min-height'] = `${window.innerHeight}px`
  belowTheFold.style.visibility = 'visible'
})

document.addEventListener('click', event => {
  if (event.target.closest('#scroll-up') !== null) {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  if (event.target.closest('#scroll-down') !== null) {
    document.getElementById('below-the-fold').scrollIntoView({block: 'start', behavior: 'smooth'})
  }
})
