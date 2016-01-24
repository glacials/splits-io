$ ->
  $("form[id='upload'] input:file").on "change", ->
    window.showSpinner "#000"
    $("form#upload").submit()
