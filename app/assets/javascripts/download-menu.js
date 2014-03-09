function show_download_menu() {
  hide_signin_menu();
  $('#download-menu').slideDown();
  setTimeout(hide_download_menu, 20000);
  $('#download-link').html('cancel');
}

function hide_download_menu() {
  $('#download-menu').slideUp();
  $('#download-link').html('download');
}

function toggle_download_menu() {
  if ($('#download-link').html() === 'download') {
    show_download_menu();
  } else {
    hide_download_menu();
  }
}
