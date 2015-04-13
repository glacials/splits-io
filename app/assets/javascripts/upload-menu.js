show_advanced_text = 'advanced +';
hide_advanced_text   = 'advanced -';

window.show_advanced_menu = function() {
  $("#advanced-menu").show();
  $("#advanced-link").html(hide_advanced_text);
};
window.hide_advanced_menu = function() {
  $("#advanced-menu").hide()
  $("#advanced-link").html(show_advanced_text);
};
window.toggle_advanced_menu = function() {
  if($("#advanced-link").html() === hide_advanced_text) {
    hide_advanced_menu();
  } else {
    show_advanced_menu();
  }
}
