function show_download_menu() {
  $('#download-menu').slideDown({ duration: 200 });
  setTimeout(hide_download_menu, 20000);
  $('#download-link').html('cancel');
}

function hide_download_menu() {
  $('#download-menu').slideUp({ duration: 200 });
  $('#download-link').html('download');
}

function toggle_download_menu() {
  if ($('#download-link').html() === 'download') {
    show_download_menu();
  } else {
    hide_download_menu();
  }
}
