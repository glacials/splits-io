@show_download_menu = ->
  $("#download-menu").slideDown duration: 200
  setTimeout hide_download_menu, 20000
  $("#download-link").html "cancel"
  return
@hide_download_menu = ->
  $("#download-menu").slideUp duration: 200
  $("#download-link").html "download"
  return
@toggle_download_menu = ->
  if $("#download-link").html() is "download"
    show_download_menu()
  else
    hide_download_menu()
  return
