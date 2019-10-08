document.addEventListener('click', event => {
  const likeButton = event.target.closest('#like-button')
  if (likeButton === null) {
    return
  }

  if (likeButton.dataset.liked === '1') {
    setNotLiked(likeButton)
    fetch(`${gon.run.id}/like`, {method: 'delete'}).then(response => {
      if (!response.ok) {
        console.log(`Error unliking run: ${error}`)
        setLiked(likeButton)
      }
    }).catch(error => {
      console.log(`Can't make the call to unlike run: ${error}`)
      setLiked(likeButton)
    })
  } else {
    setLiked(likeButton)
    fetch(`${gon.run.id}/like`, {method: 'put'}).then(response => {
      if (!response.ok) {
        console.log(`Error liking run: ${response.body}`)
        setNotLiked(likeButton)
      }
    }).catch(error => {
      console.log(`Can't make the call to like run: ${error}`)
      setNotLiked(likeButton)
    })
  }
})

const setLiked = (likeButton) => {
  likeButton.dataset.liked = '1'
  const likesCount = document.getElementById('likes-count')
  if (likesCount === null) {
    return
  }

  likeButton.classList.add('btn-dark')
  likeButton.classList.remove('btn-outline-light')
  likesCount.textContent = ++likesCount.dataset.value
}

const setNotLiked = (likeButton) => {
  likeButton.dataset.liked = '0'
  const likesCount = document.getElementById('likes-count')
  if (likesCount === null) {
    return
  }

  likeButton.classList.remove('btn-dark')
  likeButton.classList.add('btn-outline-light')
  likesCount.textContent = --likesCount.dataset.value
}
