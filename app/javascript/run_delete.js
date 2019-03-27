document.addEventListener('click', (event) => {
  if (!event.target.matches('.run-delete-button')) {
    return
  }

  const runId = event.target.dataset['runId']

  fetch(`/api/v3/runs/${runId}`, {
    method: 'DELETE'
  }).then((response) => {
    if (response.ok) {
      return response
    }

    throw response
  }).then((response) => {
    $(`#run_${runId}`).fadeOut(300, () => {
      $(this).remove()
    })
  }).catch((error) => {
    error.text().then((errorText) => {
      console.log(`Run deletion failed with response: ${errorText}`)
    })
  })
})
