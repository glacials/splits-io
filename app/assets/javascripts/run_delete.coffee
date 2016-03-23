$ ->
  window.delete_run = (runID) ->
    $.ajax
      url: '/api/v3/runs/' + runID
      type: 'DELETE'
      success: ->
        $('#run_' + runID).fadeOut 300, ->
          $(this).remove()
      error: (response) ->
        console.log 'Run deletion failed with response: ' + JSON.stringify(response.responseJSON)
