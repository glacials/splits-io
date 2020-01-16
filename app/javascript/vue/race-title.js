import raceNav from './race-nav.js'
import { getAccessToken } from '../token'
import { loadGameSelector } from '../game_select.js'
import VueBootstrapTypeahead from 'vue-bootstrap-typeahead'
const _ = require('underscore')

export default {
  components: {
    raceNav,
    VueBootstrapTypeahead,
  },
  computed: {
    categories: function() {
      if (!this.game) {
        return []
      }

      return [
        {id: null, name: '<N/A / Race-specific category>'},
        ...this.game.categories.filter(category => category.srdc_id)
      ]
    },
    category: function() {
      return this.categories.find(category => category.id === this.categoryId)
    },
    title: function() {
      if (this.race === null) {
        return ''
      }
      if (this.race.game === null && this.race.category === null && this.race.notes === null) {
        return 'Untitled race'
      }
      return `${(this.race.game || {name: ''}).name} ${(this.race.category || {name: ''}).name} ${(this.race.notes || '').split('\n')[0]}`
    },
  },
  created: async function() {
    this.notes = this.race.notes

    this.gameId = (this.race.game || {id: null}).id
    this.categoryId = (this.race.category || {id: null}).id

    this.currentUser = gon.user
    if (this.currentUser === null) {
      return
    }

    this.entry = this.race.entries.find((entry) => {
      if (!entry.runner || entry.ghost) {
        return false
      }

      return entry.runner.id === this.currentUser.id
    })

    this.game = await fetch(`/api/v4/games?search=${this.race.game.id}`).then(response => response.json()).then(body => {
      return body.games[0]
    })

    this.gameQuery = this.race.game.name
  },
  data: () => ({
    categoryId: null,
    editing: false,
    entry: null,
    error: null,
    game: null,
    gameId: null,
    gameQuery: null,
    gameResults: [],
    loading: false,
    notes: '',
  }),
  methods: {
    cancel: function() {
      this.editing = false
    },
    edit: async function() {
      this.editing = true
    },
    save: async function() {
      this.error = false
      this.loading = true
      this.editing = false

      const headers = new Headers()
      headers.append('Content-Type', 'application/json')
      const accessToken = getAccessToken()
      if (accessToken) {
        headers.append('Authorization', `Bearer ${accessToken}`)
      }

      try {
        const response = fetch(`/api/v4/races/${this.race.id}`, {
          method: 'PATCH',
          headers: headers,
          body: JSON.stringify({
            category_id: this.categoryId,
            game_id: (this.game || {}).id,
            notes: this.notes,
          })
        })

        if (!(await response).ok) {
          throw (await response.json()).error || response.statusText
        }

        this.$emit('syncing')
      } catch(error) {
        this.error = error
      } finally {
        this.loading = false
        document.getElementById('input-chat-text').focus()
      }
    },
  },
  mounted: function() {
  },
  name: 'race-title',
  props: ['race', 'starting', 'syncing'],
  watch: {
    gameId: function() {
      if (!this.game || this.game.categories.find(category => category.id === this.categoryId) === undefined) {
        this.categoryId = null
      }
    },
    gameQuery: _.debounce(function(newGame) {
      fetch(`/api/v4/games?search=${newGame}`).then(response => response.json()).then(body => {
        this.gameResults = body.games
      })
    }, 500)
  },
}
