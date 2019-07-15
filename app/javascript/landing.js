import {buildRunDurationChart} from "charts/run_duration.js"
import {buildResetChart} from "charts/reset.js"
import {buildPlaytimeChart} from "charts/playtime.js"
import {buildSegmentChart} from "charts/segment.js"
import {buildSegmentDurationChart} from "charts/segment_duration.js"
import {example_run} from "example_run.js"
import {example_segment} from "example_run.js"

const options = {
  exporting: {enabled: false},
  title: {text: ''},
}

document.addEventListener('turbolinks:load', () => {
  if (window.location.pathname !== '/' || gon.user !== null) {
    return
  }

  buildRunDurationChart([example_run], options)
  buildResetChart(      [example_run], options)
  buildPlaytimeChart(   [example_run], options)
  buildSegmentChart(    [example_run], options)
  buildSegmentDurationChart('real', [example_run], [example_segment], {})

  const aboveTheFold = document.getElementById('above-the-fold')
  const belowTheFold = document.getElementById('below-the-fold')
})

document.addEventListener('click', event => {
  if (event.target.closest('#scroll-up') !== null) {
    window.scrollTo({top: 0, behavior: 'smooth'});
  }

  if (event.target.closest('#scroll-down') !== null) {
    document.getElementById('below-the-fold').scrollIntoView({block: 'start', behavior: 'smooth'})
  }
})
