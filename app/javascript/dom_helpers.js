const createAlert = (style, message) => {
  const div = document.createElement('div')
  div.classList = `alert alert-${style} center`
  div.setAttribute('role', 'alert')
  div.innerText = message
  return div
}

export { createAlert }
