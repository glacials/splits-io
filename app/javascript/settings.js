document.addEventListener('turbolinks:load', () => {
  clipboard = new Clipboard('.clipboard-btn')

  clipboard.on('success', (event) => {
    event.trigger.children[0].style.display = 'none'
    event.trigger.children[1].style.display = 'inline-block'
    setTimeout(() => {
      event.trigger.children[0].style.display = 'inline-block'
      event.trigger.children[1].style.display = 'none'
    }, 4000)
  })
})
