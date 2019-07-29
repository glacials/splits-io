import Multiselect from 'vue-multiselect'

export default {
  components: {
    Multiselect
  },
  computed: {
    options: function() {
      return this.race.entries.filter(entry => !entry.ghost && entry.creator.twitch_name !== null).map(entry => {
        return {name: entry.creator.display_name, id: entry.creator.twitch_name}
      })
    },

    finished: function() {
      return this.race.entries.every(entry => entry.forfeited_at || entry.finished_at)
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
    ratioHeight: function(div) {
      const width = div.offsetWidth

      return (width / 16) * 9
    }
  },

  updated: function() {
    this.value.forEach(stream => {
      const div = document.getElementById(`twitch-${stream.id}`)
      const child = div.firstChild
      if (div.dataset.loaded === '1') {
        child.height = this.ratioHeight(div)
        return
      }

      div.dataset.loaded = '1'
      new Twitch.Player(div.id, {
        autoplay: true,
        channel: stream.id,
        muted: true,
        height: this.ratioHeight(div),
        width: '100%'
      })
    })
  },
  name: 'race-streams',
  props: ['race']
}
