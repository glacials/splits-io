const createAlert = (style, message) => {
  const div = document.createElement('div')
  div.classList = `alert alert-${style} center`
  div.setAttribute('role', 'alert')
  div.innerText = message
  return div
}

const showButton = (elementId) => {
  const elem = document.getElementById(elementId)
  elem.hidden = false
}

const hideButton = (elementId) => {
  const elem = document.getElementById(elementId)
  elem.hidden = true
}

export { createAlert, showButton, hideButton }
