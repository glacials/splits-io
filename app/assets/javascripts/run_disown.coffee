$ ->
  window.disown_run = (run) ->
    $("#run_" + run.id).fadeOut 300, ->
      $(this).remove()
    $.ajax
      url: "/api/v3/runs/" + run.id + "/disown"
      type: "POST"
      error: (response) ->
        console.log "Run disown failed with response: " + JSON.stringify(response)
