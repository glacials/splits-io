import raceNav from './race-nav.js'
import { getAccessToken } from '../token'
import { loadGameSelector } from '../game_select.js'
import GameSelector from './GameSelector.vue'
import CategorySelector from './CategorySelector.vue'
const _ = require('underscore')

export default {
  components: {
    raceNav,
    GameSelector,
    CategorySelector,
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
    this.category = this.race.category

    const currentUser = gon.user
    if (!currentUser) {
      return
    }

    this.entry = this.race.entries.find(entry => {
      if (!entry.runner || entry.ghost) {
        return false
      }

      return entry.runner.id === currentUser.id
    })

    if (this.race.game) {
      this.game = await fetch(`/api/v4/games?search=${this.race.game.id}`).then(response => response.json()).then(body => {
        return body.games[0]
      })
    }
  },
  data: () => ({
    category: null,
    editing: false,
    entry: null,
    error: null,
    game: null,
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
            category_id: (this.category && this.category.id) || null,
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
}
