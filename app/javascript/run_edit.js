window.update_category_selector = function(game_shortname) {
  select = document.getElementById(gon.run.id + '_category')
  document.getElementById('game_category_submit').disabled = true
  for(option of select.children) {
    option.remove()
  }
  option = document.createElement('option')
  option.text = 'Loading...'
  select.appendChild(option)

  fetch('/api/v4/games/' + game_shortname).then(function(response) {
    return response.json()
  }).then(function(response) {
    for(option of select.children) {
      option.remove()
    }
    response.game.categories.forEach(function(category) {
      const option = document.createElement('option')
      option.value = category.id
      option.text = category.name
      select.appendChild(option)
    })
    document.getElementById('game_category_submit').disabled = false
  })
}
