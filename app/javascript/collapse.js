document.addEventListener('turbolinks:load', () => {
  const deleteButton = document.querySelector('#delete-header button')
  if (!deleteButton) {
    retrun
  }
  deleteButton.addEventListener('click', event => setTimeout(() => event.target.scrollIntoView({behavior: 'smooth'}), 300))
})
