document.addEventListener('mouseover', event => {
  const segment = event.target.closest('.split')
  if (segment === null) {
    return
  }

  const run_id = segment.dataset.run_id
  const segment_number = segment.dataset.segment_number
  const query = `.segment-inspect[data-run_id='${run_id}'][data-segment_number='${segment_number}']`
  document.querySelector(query).style.visibility = 'visible'
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
})
