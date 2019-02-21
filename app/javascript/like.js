document.addEventListener('click', event => {
  const likeButton = event.target.closest('#like-button')
  const likesCount = document.getElementById('likes-count')
  if (likeButton === null || likesCount === null) {
    return
  }

  likeButton.classList.toggle('btn-danger')
  likeButton.classList.toggle('btn-outline-danger')

  if (likeButton.dataset.liked === '1') {
    likeButton.dataset.liked = '0'
    likesCount.textContent = --likesCount.dataset.value

    fetch(`${gon.run.id}/like`, {method: 'delete'})
  } else {
    likeButton.dataset.liked = '1'
    likesCount.textContent = ++likesCount.dataset.value

    fetch(`${gon.run.id}/like`, {method: 'put'})
  }
})
