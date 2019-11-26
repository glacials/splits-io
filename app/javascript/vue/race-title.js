import raceNav from './race-nav.js'
import { getAccessToken } from '../token'

export default {
  components: {
    raceNav,
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
    game: function() {
      return this.games.find(game => game.id === this.gameId)
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
    this.games = (await (fetch('/api/v4/games').then(response => response.json()))).games

    this.gameId = (this.race.game || {id: null}).id
    this.categoryId = (this.race.category || {id: null}).id
  },
  data: () => ({
    categoryId: null,
    editing: false,
    error: null,
    gameId: null,
    games: [],
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
  name: 'race-title',
  props: ['race', 'starting', 'syncing'],
  watch: {
    gameId: function() {
      if (this.game.categories.find(category => category.id === this.categoryId) === undefined) {
        this.categoryId = null
      }
    },
  },
}
