$ ->
  window.delete_run = (run) ->
    $('#run_' + run.id).fadeOut 300, ->
      $(this).remove()
  $.ajax
    url: '/api/v3/runs/' + run.id
    type: 'DELETE'
    error: (response) ->
      console.log 'Run deletion failed with response: ' + JSON.stringify(response.responseJSON)
