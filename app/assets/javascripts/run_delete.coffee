$ ->
  window.delete_run = (run) ->
    $.ajax
      url: '/api/v3/runs/' + run.id
      type: 'DELETE'
      success: ->
        $('#run_' + run.id).fadeOut 300, ->
          $(this).remove()
      error: (response) ->
        console.log 'Run deletion failed with response: ' + JSON.stringify(response.responseJSON)
