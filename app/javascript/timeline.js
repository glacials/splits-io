let currentTimelineRunId = ''
const timelineMouseOverTimers = {}
const timelineMouseOutTimers = {}

const mouseOverSegment = (segment) => {
  const run_id = segment.dataset.run_id
  const segment_number = segment.dataset.segment_number
  const timerKey = `${run_id}-${segment_number}`
  timelineMouseOverTimers[timerKey] = undefined

  const leftEdge = segment.offsetLeft
  const otherTimelinesQuery = `.split[data-segment_number='${segment_number}']:not([data-run_id='${run_id}'])`
  document.querySelectorAll(otherTimelinesQuery).forEach((el) => {
    const otherLeftEdge = el.offsetLeft
    const timeline = el.closest('.timeline-background')
    const goldTimeline = timeline.parentElement.querySelector('.gold.timeline')
    const videoProgressLine = document.getElementById(`video-progress-line-${el.dataset.run_id}`)
    const offset = leftEdge - otherLeftEdge
    timeline.style.left = `${offset}px`
    goldTimeline.style.left = `${offset}px`
    if (videoProgressLine !== null) {
      videoProgressLine.style.left = `${offset}px`
    }
  })
}

const mouseOutSegment = (segment) => {
  const run_id = segment.dataset.run_id
  const segment_number = segment.dataset.segment_number
  const timerKey = `${run_id}-${segment_number}`
  timelineMouseOutTimers[timerKey] = undefined

  if (currentTimelineRunId === run_id) {
    // We are moving between segments on the same timeline, so don't shift
    // the other timelines back to their origins as they'll just get moved
    // to a new position momentarily and there will be an annoying visual jump
    return
  }

  const otherTimelinesQuery = `.timeline-background:not([data-run_id='${run_id}'])`
  document.querySelectorAll(otherTimelinesQuery).forEach((timeline) => {
    const goldTimeline = timeline.parentElement.querySelector('.gold.timeline')
    const videoProgressLine = document.getElementById(`video-progress-line-${timeline.dataset.run_id}`)
    timeline.style.left = '0px'
    goldTimeline.style.left = '0px'
    if (videoProgressLine !== null) {
      videoProgressLine.style.left = '0px'
    }
  })
}

document.addEventListener('mouseover', event => {
  const segment = event.target.closest('.split')
  if (segment === null) {
    // We're no longer over a timeline, so there is no currentTimelineRunId
    currentTimelineRunId = ''
    return
  }

  const run_id = segment.dataset.run_id
  currentTimelineRunId = run_id
  const segment_number = segment.dataset.segment_number
  const timerKey = `${run_id}-${segment_number}`

  // Go aheand and show the timeline inspector
  const query = `.segment-inspect[data-run_id='${run_id}'][data-segment_number='${segment_number}']`
  document.querySelector(query).style.visibility = 'visible'


  if (timelineMouseOutTimers[timerKey] !== undefined) {
    // We moved off of this segment and then back on
    // So don't do the mouseout stuff since our mouse is no longer out
    clearTimeout(timelineMouseOutTimers[timerKey])
    timelineMouseOutTimers[timerKey] = undefined
  }
  if (timelineMouseOverTimers[timerKey] !== undefined) {
    // We already have a timer running for this segment; don't start another
    return
  }

  timelineMouseOverTimers[timerKey] = setTimeout(mouseOverSegment.bind(null, segment), 100)
})

document.addEventListener('mouseout', event => {
  const segment = event.target.closest('.split')
  if (segment === null) {
    return
  }

  const run_id = segment.dataset.run_id
  const segment_number = segment.dataset.segment_number

  // Go ahead and hide the timeline inspector
  const query = `.segment-inspect[data-run_id='${run_id}'][data-segment_number='${segment_number}']`
  document.querySelector(query).style.visibility = 'hidden'

  const timerKey = `${run_id}-${segment_number}`
  if (timelineMouseOverTimers[timerKey] !== undefined) {
    // We just moved our mouse over this segment and then out of it
    // So we don't want to actually do mouseover stuff for it
    // since we're no longer over it
    clearTimeout(timelineMouseOverTimers[timerKey])
    timelineMouseOverTimers[timerKey] = undefined
  }

  if (timelineMouseOutTimers[timerKey] !== undefined) {
    // We already have a timer running for this segment; don't start another
    return
  }

  timelineMouseOutTimers[timerKey] = setTimeout(mouseOutSegment.bind(null, segment), 100)
})
