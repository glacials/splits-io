$ ->
  window.showSpinner = (color) ->
    window.spinner = new Spinner(
      lines: 3
      length: 15
      width: 1
      radius: 0
      corners: 1
      rotate: 90
      direction: 1
      color: color
      speed: 0.5
      trail: 30
      shadow: false
      hwaccel: true
      className: "spinner"
      zIndex: 2e9
    ).spin()
    document.body.appendChild window.spinner.el

  window.hideSpinner = -> window.spinner.stop
