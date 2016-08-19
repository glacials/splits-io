$ ->
  $("form[id='upload'] input:file").on "change", ->
    window.showSpinner "#000"
    window.isUploading = true
    window.upload document.getElementById('file').files[0]
