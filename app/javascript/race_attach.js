document.addEventListener('direct-uploads:end', () => {
  Array.from(document.querySelectorAll('form > input[type=file]')).forEach(input => {
    input.value = null
    input.disabled = false
  })
  Array.from(document.querySelectorAll('form > input[type=submit]')).forEach(input => {
    input.disabled = false
  })
})
