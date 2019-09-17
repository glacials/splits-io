document.addEventListener('mouseover', event => {
  const segment = event.target.closest('.split')
  if (segment === null) {
    return
  }

  const run_id = segment.dataset.run_id
  const segment_number = segment.dataset.segment_number
  const query = `.segment-inspect[data-run_id='${run_id}'][data-segment_number='${segment_number}']`
  const leftEdge = segment.offsetLeft
  document.querySelector(query).style.visibility = 'visible'
  document.querySelectorAll(`.split[data-segment_number='${segment_number}']:not([data-run_id='${run_id}'])`).forEach((el) => {
    const otherLeftEdge = el.offsetLeft
    const timeline = el.closest('.timeline-background')
    const goldTimeline = timeline.parentElement.querySelector('.gold.timeline')
    const offset = leftEdge - otherLeftEdge
    timeline.style.position = 'relative'
    timeline.style.left = `${offset}px`
    goldTimeline.style.position = 'relative'
    goldTimeline.style.left = `${offset}px`
  })
})

document.addEventListener('mouseout', event => {
  const segment = event.target.closest('.split')
  if (segment === null) {
    return
  }

  const run_id = segment.dataset.run_id
  const segment_number = segment.dataset.segment_number
  const query = `.segment-inspect[data-run_id='${run_id}'][data-segment_number='${segment_number}']`
  document.querySelector(query).style.visibility = 'hidden'
  document.querySelectorAll(`.split[data-segment_number='${segment_number}']:not([data-run_id='${run_id}'])`).forEach((el) => {
    const timeline = el.closest('.timeline-background')
    const goldTimeline = timeline.parentElement.querySelector('.gold.timeline')
    timeline.style.position = ""
    timeline.style.left = ""
    goldTimeline.style.position = ""
    goldTimeline.style.left = ""
  })
})
