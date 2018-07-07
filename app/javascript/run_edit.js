document.addEventListener('turbolinks:load', function() {
  const gameSelect     = document.getElementById('game-selector')
  const categorySelect = document.getElementById('category-selector')
  const saveButton     = document.getElementById('game-category-submit')

  const loading = document.createElement('option')
  loading.text = 'Loading...'

  gameSelect.addEventListener('change', function(event) {
    saveButton.disabled = true
    categorySelect.disabled = true
    for(option of categorySelect.children) {
      option.remove()
    }
    categorySelect.appendChild(loading)

    fetch(`/api/v4/games/${this.value}`).then(function(response) {
      return response.json()
    }).then(function(response) {
      for(option of categorySelect.children) {
        option.remove()
      }
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
