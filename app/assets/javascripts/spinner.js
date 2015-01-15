$(function () {
  window.showSpinner = function(color) {
    window.spinner = new Spinner({
      lines: 3,
      length: 15, // The length of each line
      width: 1, // The line thickness
      radius: 0, // The radius of the inner circle
      corners: 1, // Corner roundness (0..1)
      rotate: 90, // The rotation offset
      direction: 1, // 1: clockwise, -1: counterclockwise
      color: color, // #rgb or #rrggbb or array of colors
      speed: 0.5, // Rounds per second
      trail: 30, // Afterglow percentage
      shadow: false, // Whether to render a shadow
      hwaccel: true, // Whether to use hardware acceleration
      className: 'spinner', // The CSS class to assign to the spinner
      zIndex: 2e9, // The z-index (defaults to 2000000000)
    }).spin();
    document.body.appendChild(window.spinner.el);
  };

  window.hideSpinner = function() {
    window.spinner.stop();
  };
});
