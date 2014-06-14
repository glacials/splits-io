download_text = 'download'
cancel_text   = 'cancel'

@show_download_menu = ->
  $("#download-menu").show()
  $("#download-menu").animate {width: '50%'}, 200
  #setTimeout hide_download_menu, 20000
  $("#download-link").html cancel_text
  return
@hide_download_menu = ->
  $("#download-menu").animate {width: '0%'}, 200, ->
    $("#download-menu").hide()
  $("#download-link").html download_text
  return
@toggle_download_menu = ->
  if $("#download-link").html() is cancel_text
    hide_download_menu()
  else
    show_download_menu()
  return
