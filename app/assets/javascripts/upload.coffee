$ ->
  uploadFile = (file) ->
    li = document.createElement("div")
    img = undefined
    progressBarContainer = document.createElement("div")
    progressBar = document.createElement("div")
    reader = undefined
    xhr = undefined
    fileInfo = undefined
    progressBarContainer.className = "progress-bar-container"
    progressBar.className = "progress-bar"
    progressBarContainer.appendChild progressBar
    li.appendChild progressBarContainer

    # If the file is an image and the web browser supports FileReader, # present a preview in the file list
    if typeof FileReader isnt "undefined" and (/image/i).test(file.type)
      img = document.createElement("img")
      li.appendChild img
      reader = new FileReader()
      reader.onload = ((theImg) ->
        (evt) ->
          theImg.src = evt.target.result
          return
      (img))
      reader.readAsDataURL file
    formData = new FormData()
    xhr = new XMLHttpRequest()
    formData.append "authenticity_token", $("meta[name=\"csrf-token\"]").attr("content")
    formData.append "file", file
    xhr.open "POST", "/upload.json", true
    xhr.onload = ->
      if xhr.status is 200
        console.log "all done: " + xhr.status
        window.location = JSON.parse(xhr.responseText).url
      else
        console.log "Something went wrong..."
      return

    xhr.setRequestHeader "accept", "*/*;q=0.5, text/javascript"
    xhr.send formData

    # Present file info and append it to the list of files
    $("#droplabel").html "parsing..."
    fileList.appendChild li
    return
  traverseFiles = (files) ->
    if typeof files isnt "undefined"
      i = 0
      l = files.length

      while i < l
        uploadFile files[i]
        i++
    else
      fileList.innerHTML = "No support for the File API in this web browser"
    return
  dropArea = document.getElementById("dropzone")
  fileList = document.getElementById("file-list")
  dropArea.addEventListener "dragleave", ((evt) ->
    target = evt.target
    @className = ""  if target and target is dropArea
    evt.preventDefault()
    evt.stopPropagation()

    # We have to double-check the 'leave' event state because this event stupidly gets fired by JavaScript when you
    # mouse over the child of a parent element; instead of firing a subsequent enter event for the child, JavaScript
    # first fires a LEAVE event for the parent then an ENTER event for the child even though the mouse is still
    # technically inside the parent bounds. If we trust the dragenter/dragleave events as-delivered, it leads to
    # "flickering" when a child element (drop prompt) is hovered over as it becomes invisible, then visible then
    # invisible again as that continually triggers the enter/leave events back to back. Instead, we use a 10px buffer
    # around the window frame to capture the mouse leaving the window manually instead. (using 1px didn't work as the
    # mouse can skip out of the window before hitting 1px with high enough acceleration).
    $("#dropzone-overlay").fadeOut 125  if evt.pageX < 10 or evt.pageY < 10 or $(window).width() - evt.pageX < 10 or $(window).height - evt.pageY < 10
    return
  ), false
  dropArea.addEventListener "dragenter", ((evt) ->
    @className = "over"
    evt.preventDefault()
    evt.stopPropagation()
    $("#dropzone-overlay").fadeTo 125, .9
    return
  ), false
  dropArea.addEventListener "dragover", ((evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    return
  ), false
  dropArea.addEventListener "drop", ((evt) ->
    traverseFiles evt.dataTransfer.files
    @className = ""
    evt.preventDefault()
    evt.stopPropagation()
    return
  ), false
  return
