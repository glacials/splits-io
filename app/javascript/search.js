import Bloodhound from 'typeahead.js'
import Handlebars from 'handlebars'

document.addEventListener("turbolinks:before-cache", function() {
  $('.search').typeahead('destroy')
})

document.addEventListener('turbolinks:load', function() {
  $('.search').typeahead({
    minLength: 3,
    classNames: {
      input: 'text-light bg-default',
      hint: 'text-muted',
      menu: 'dropdown-menu bg-dark',
      selectable: 'dropdown-item text-secondary',
      cursor: 'active'
    }
  },
  {
    name: 'games',
    display: function(game) {
      return game.name
    },
    source: new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.whitespace,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: '/api/v4/games',
        prepare: function(query, settings) {
          return Object.assign(settings, {url: encodeURI(`${settings.url}?search=${query.trim()}`)})
        },
        transform: function(response) {
          return response.games.map(function(game) {
            return Object.assign(game, {'_type': 'game'})
          })
        }
      },
      identify: function(game) {
        return game.id
      }
    }),
    templates: {
      notFound: '<div class="dropdown-header"><h5>Games</h5></div><div class="dropdown-item disabled"><i>No games found</i></div>',
      pending: '<div class="dropdown-header"><i>Searching games...</i></div>',
      header: '<div class="dropdown-header"><h5>Games</h5></div>',
      suggestion: Handlebars.compile(`
        <a href="/games/{{shortname}}" class="dropdown-item">
          {{name}}<br />
          <small>{{categories.length}} categories</small>
        </a>
      `)
    }
  },
  {
    name: 'runners',
    display: function(runner) {
      return runner.display_name
    },
    source: new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.whitespace,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: '/api/v4/runners',
        prepare: function(query, settings) {
          return Object.assign(settings, {url: encodeURI(`${settings.url}?search=${query.trim()}`)})
        },
        transform: function(response) {
          return response.runners.map(function(runner) {
            return Object.assign(runner, {'_type': 'runner'})
          })
        }
      },
      identify: function(runner) {
        return runner.id
      }
    }),
    templates: {
      notFound: '<div class="dropdown-header"><h5>Runners</h5></div><div class="dropdown-item disabled"><i>No runners found</i></div>',
      pending: '<div class="dropdown-header"><i>Searching runners...</i></div>',
      header: '<div class="dropdown-header"><h5>Runners</h5></div>',
      suggestion: Handlebars.compile(`
        <a href="/users/{{name}}" class="dropdown-item">
          {{display_name}}
        </a>
      `)
    }
  })
})
