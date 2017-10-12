$(function() {
  let f = function() {
    let data = $('body').data();
    $(document).trigger(data.controller + '#' + data.action + ':loaded');
  };

  // Assign the event listener but also call the function, because by now we've missed the turbolinks:load event that
  // fires on pageload.
  document.addEventListener("turbolinks:load", f);
  f();
});
