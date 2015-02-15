download_text = '↓ download';
cancel_text   = 'cancel';

window.show_download_menu = function() {
  $("#download-menu").show();
  $("#download-menu").animate({width: '50%'}, 200);
  $("#download-link").html(cancel_text);
};
window.hide_download_menu = function() {
  $("#download-menu").animate({width: '0%'}, 200, function() {
    $("#download-menu").hide()
  });
  $("#download-link").html(download_text);
};
window.toggle_download_menu = function() {
  if($("#download-link").html() === cancel_text) {
    hide_download_menu();
  } else {
    show_download_menu();
  }
}
