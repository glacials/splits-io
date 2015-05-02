$ ->
  window.disown_run = (run) ->
    $("#run_" + run.id).fadeOut 300, ->
      $(this).remove()
    $.ajax
      url: "/api/v2/runs/" + run.id + "/user"
      type: "DELETE"
      error: (response) ->
        console.log "Run disown failed with response: " + JSON.stringify(response)
