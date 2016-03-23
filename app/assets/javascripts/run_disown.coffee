$ ->
  window.disown_run = (runID) ->
    $.ajax
      url: "/api/v3/runs/" + runID + "/disown"
      type: "POST"
      success: ->
        $("#run_" + runID).addClass("faded")
        $("#run_" + runID + " > td > div.dropdown").remove()
      error: (response) ->
        console.log "Run disown failed with response: " + JSON.stringify(response)
