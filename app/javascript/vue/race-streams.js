import Multiselect from 'vue-multiselect'

export default {
  components: {
    Multiselect
  },
  computed: {
    options: function() {
      return this.race.entries.map((entry) => {
        return {name: entry.creator.display_name, id: entry.creator.twitch_name}
      }).filter((entry) => {
        return entry.id !== null
      })
    },

    minHeight: function() {
      if (this.value.length >= 3) {
        return '300px'
      } else if (this.value.length === 2) {
        return '390px'
      } else {
        return '480px'
      }
    }
  },
  watch: {
    options: function(entries) {
      const currentEntries = entries.map(entry => entry.id)
      this.value = this.value.filter(entry => currentEntries.includes(entry.id))
    }
  },
  created: function() {

  },
  data: () => ({
    value: []
  }),
  methods: {

  },

  updated: function() {
    this.value.forEach(stream => {
      const div = document.getElementById(`twitch-${stream.id}`)
      if (div.dataset.loaded === '1') {
        div.firstChild.height = this.minHeight
        return
      }

      div.dataset.loaded = '1'
      new Twitch.Player(div.id, {
        autoplay: true,
        channel: stream.id,
        muted: true,
        height: this.minHeight,
        width: '100%'
      })
    })
  },
  name: 'race-streams',
  props: ['race']
}
