document.addEventListener('turbolinks:load', function() {
  const gameSelect     = document.getElementById('game-selector')
  const categorySelect = document.getElementById('category-selector')
  const saveButton     = document.getElementById('game-category-submit')

  const loading = document.createElement('option')
  loading.text = 'Loading...'

  if(gameSelect === null) {
    return
  }

  gameSelect.addEventListener('change', function(event) {
    saveButton.disabled = true
    categorySelect.disabled = true
    Array.from(categorySelect.children).forEach((option) => option.remove())
    categorySelect.appendChild(loading)

    fetch(`/api/v4/games/${this.value}`).then(function(response) {
      return response.json()
    }).then(function(response) {
      Array.from(categorySelect.children).forEach((option) => option.remove())
      response.game.categories.forEach(function(category) {
        const option = document.createElement('option')
        option.value = category.id
        option.text = category.name
        categorySelect.appendChild(option)
      })
      saveButton.disabled = false
      categorySelect.disabled = false
    })
  })
})
