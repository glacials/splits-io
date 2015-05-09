window.toggleDarkmode = ->
  $.cookie "darkmode", (if $.cookie("darkmode") is "1" then "0" else "1")
  location.reload()
