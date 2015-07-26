$ ->
  window.disown_run = (run) ->
    $.ajax
      url: "/api/v3/runs/" + run.id + "/disown"
      type: "POST"
      success: ->
        $("#run_" + run.id).fadeOut 300, ->
          $(this).remove()
      error: (response) ->
        console.log "Run disown failed with response: " + JSON.stringify(response)
