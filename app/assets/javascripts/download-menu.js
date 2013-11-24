function show_download_menu() {
  $("#footer").slideUp();
  $("#download-menu").slideDown();
  setTimeout(hide_download_menu, 20000);
}

function hide_download_menu() {
  $("#download-menu").slideUp();
  $("#footer").slideDown();
}
