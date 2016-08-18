$ ->
  window.upload = (file, options) ->
    if !file?
      $("#droplabel").html "that looks like an empty file :("
      window.isUploading = false
      return
    options = options or bulk: false
    $.ajax
      method: "POST"
      url: "/api/v4/runs"
      cache: false
      processData: false
      contentType: false
      success: (response, textStatus, xhr) ->
        localStorage.setItem "claim_tokens/" + response.id, response.claim_token

        formData = new FormData()
        for key, val of response.presigned_request.fields
          formData.append(key, val)
        formData.append('file', file)
        $.ajax
          method: response.presigned_request.method
          url: response.presigned_request.uri
          cache: false
          processData: false
          contentType: false
          data: formData
          success: ->
            window.location = response.uris.claim_uri unless options.bulk
          error: (xhr, textStatus) ->
            window.isUploading = false
            $("#droplabel").html "oops, got a " + xhr.status + " (" + xhr.statusText + ").<br />try again, or contact glacials.<br />"
            window.spinner.stop()

      error: (xhr, textStatus) ->
        if xhr.status is 400
          window.location = "/cant-parse" unless options.bulk
        else
          window.isUploading = false
          $("#droplabel").html "oops, got a " + xhr.status + " (" + xhr.statusText + ").<br />try again, or contact glacials.<br />"
          window.spinner.stop()


  window.uploadAll = (files) ->
    $("#multiupload").show()
    Promise.all(files.map((file) ->
      new Promise((resolve, reject) ->
        window.upload(file,
          bulk: true
        ).then (->
          $("#successful-uploads").html Number($("#successful-uploads").html()) + 1
          resolve()
        ), (err) ->
          $("#failed-uploads").html Number($("#failed-uploads").html()) + 1
          resolve()

      )
    )).then ->
      window.location = "/"


  $("#dropzone").on "dragenter", (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    $("#dropzone-overlay").fadeTo 125, .9

  $("#dropzone").on "dragleave", (evt) ->
    $("#dropzone-overlay").fadeOut 125  if event.pageX < 10 or event.pageY < 10 or $(window).width() - event.pageX < 10 or $(window).height - event.pageY < 10

  $("#dropzone").on "dragover", (evt) ->
    evt.preventDefault()
    evt.stopPropagation()

  $("#dropzone").on "drop", (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    files = evt.originalEvent.dataTransfer.files
    if files.length > 1 and gon.user is null
      $("#droplabel").html "to upload more than one file at a time, please sign in."
      return
    $("#droplabel").html "parsing..."
    window.isUploading = true
    window.showSpinner "#fff"
    if files.length > 1
      window.uploadAll _.toArray(files)
    else
      window.upload files[0]

  $("#dropzone").click (evt) ->
    $("#dropzone-overlay").fadeOut 125  unless window.isUploading

  $(document).keyup (evt) ->
    $("#dropzone-overlay").fadeOut 125  if not window.isUploading and evt.keyCode is 27
