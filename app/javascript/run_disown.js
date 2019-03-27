document.addEventListener('click', (event) => {
  if (!event.target.matches('.run-disown-button')) {
    return
  }

  const runId = event.target.dataset['runId']

  fetch(`/api/v3/runs/${runId}/disown`, {
    method: 'POST'
  }).then((response) => {
    if (response.ok) {
      return response
    }

    throw response
  }).then((response) => {
    document.getElementById(`run_${runId}`).style.opacity = .2
    document.querySelector(`#run_${runId} > td > .dropleft`).remove()
  }).catch((error) => {
    error.text().then((errorText) => {
      console.log(`Run deletion failed with response: ${errorText}`)
    })
  })
})
