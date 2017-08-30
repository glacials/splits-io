download_text = '↓ download'
cancel_text = 'cancel'

window.show_download_menu = ->
  $('#download-menu').css("visibility", "visible");
  $('#download-menu').animate { width: '50%' }, 200
  $('#download-link').html cancel_text

window.hide_download_menu = ->
  $('#download-menu').animate { width: '0%' }, 200, ->
    $('#download-menu').css("visibility", "hidden");
    $('#download-link').html download_text

window.toggle_download_menu = ->
  if $('#download-link').html() == cancel_text
    hide_download_menu()
  else
    show_download_menu()
