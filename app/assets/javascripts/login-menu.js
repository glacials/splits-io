function show_signin_menu() {
  hide_download_menu();
  $('#signin-menu').slideDown();
  setTimeout(hide_signin_menu, 20000);
  $('#signin-link').html('cancel');
}

function hide_signin_menu() {
  $('#signin-menu').slideUp();
  $('#signin-link').html('sign in');
}

function toggle_signin_menu() {
  if ($('#signin-link').html() === 'sign in') {
    show_signin_menu();
  } else {
    hide_signin_menu();
  }
}
