$ ->
  window.disown_run = (run) ->
    $.ajax
      url: "/api/v3/runs/" + run.id + "/disown"
      type: "POST"
      success: ->
        $("#run_" + run.id).addClass("faded")
        $("#run_" + run.id + " > td > div.dropdown").remove()
      error: (response) ->
        console.log "Run disown failed with response: " + JSON.stringify(response)
