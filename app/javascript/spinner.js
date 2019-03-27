import {Spinner} from 'spin.js'

const opts = {
  lines: 3,
  length: 15,
  width: 1,
  radius: 0,
  corners: 1,
  rotate: 90,
  direction: 1,
  color: '#FFFFFF',
  speed: 0.5,
  trail: 30,
  shadow: false,
  hwaccel: true
}

let globalSpinner = null

const createSpinner = function(spinnerOptions = {}) {
  const newOptions = Object.assign(opts, spinnerOptions)
  return new Spinner(newOptions)
}

const showSpinner = function(spinnerOptions = {}) {
  if (globalSpinner !== null) {
    globalSpinner.stop()
  }

  const newOptions = Object.assign({
    className: 'spinner',
    zIndex: 2e9
  }, spinnerOptions)
  const spinner = createSpinner(newOptions)

  spinner.spin(document.body)
}

const hideSpinner = function() {
  if (globalSpinner === null) {
    return
  }

  globalSpinner.stop()
}

export {createSpinner, showSpinner, hideSpinner}
