import typeahead from "typeahead.js";
import Bloodhound from 'bloodhound-js'
import Handlebars from 'handlebars'

document.addEventListener('turbolinks:before-cache', function() {
  $('.game-select').typeahead('destroy')
})

const loadGameSelector = function() {
  $('.game-select').typeahead({
    minLength: 3,
    classNames: {
      hint: 'text-muted',
      menu: 'dropdown-menu',
      selectable: 'dropdown-item',
      cursor: 'active'
    }
  },
  {
    name: 'games',
    display: game => game.name,
    source: new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.whitespace,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: '/api/v4/games',
        prepare: function(query, settings) {
          return Object.assign(settings, {url: encodeURI(`${settings.url}?search=${query.trim()}`)})
        },
        transform: response => response.games.map(game => Object.assign(game, {'_type': 'game'})),
      },
      identify: game => game.id,
    }),
    templates: {
      notFound: '<div class="dropdown-header"><h5>Games</h5></div><div class="dropdown-item disabled"><i>No games found</i></div>',
      pending: '<div class="dropdown-header"><i>Searching games...</i></div>',
      suggestion: Handlebars.compile(`
        <div class="dropdown-item change-selected-game" data-id='{{id}}'>
          {{name}}<br />
          <small>{{categories.length}} categories</small>
        </div>
      `)
    }
  })
}

document.addEventListener('turbolinks:load', loadGameSelector)

document.addEventListener('click', function(event) {
  if (!event.target.closest('.change-selected-game')) {
    return
  }

  document.getElementById('selected-game-id').value = event.target.dataset['id']
  document.getElementById('category-selector').focus()

  const categorySelect = document.getElementById('category-selector')
  const saveButton     = document.getElementById('game-category-submit')
  const loading = document.createElement('option')
  loading.text = 'Loading...'

  Array.from(categorySelect.children).forEach((option) => option.remove())
  categorySelect.appendChild(loading)

  fetch(`/api/v4/games?search=${document.getElementById('selected-game-id').value}`).then(response => response.json()).then(response => {
    Array.from(categorySelect.children).forEach((option) => option.remove())
    response.games[0].categories.forEach(category => {
      const option = document.createElement('option')
      option.value = category.id
      option.text = category.name
      categorySelect.appendChild(option)
    })
    saveButton.disabled = false
    categorySelect.disabled = false
  })
})

export { loadGameSelector }
