document.addEventListener('click', event => {
  if (event.target.closest('#scroll-up') !== null) {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  if (event.target.closest('#scroll-down') !== null) {
    document.getElementById('below-the-fold').scrollIntoView({ block: 'start', behavior: 'smooth' })
  }
})
