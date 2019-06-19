export default {
  data: () => ({
    error: null,
    loading: false,

    bingo_card_url: '',
    notes: '',
    seed_name: '',
    visibility: 'public',
  }),
  methods: {
    createBingo: function() {
      this.create('bingo')
    },
    createRace: function() {
      this.create('race')
    },
    createRandomizer: function() {
      this.create('randomizer')
    },
    create: async function(raceableType) {
      try {
        this.loading = true
        this.error = null

        const response = await fetch(`/api/v4/${raceableType}s`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('splitsio_access_token')}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            game_id: this.gameId,
            category_id: this.categoryId,
            visibility: this.visibility,
            notes: this.notes,
            card_url: this.bingo_card_url,
            seed: this.seed_name,
          })
        })

        if (!response.ok) {
          throw (await response.json()).error || response.statusText
        }

        Turbolinks.visit((await response.json())[raceableType].path)
      } catch(error) {
        this.error = `Error: ${error}`
      } finally {
        this.loading = false
      }
    },
  },
  name: 'race-create',
  props: ['category-id', 'game-id'],
}
