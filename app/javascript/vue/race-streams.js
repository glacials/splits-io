import Multiselect from 'vue-multiselect'

export default {
  components: {
    Multiselect
  },
  computed: {
    options: function() {
      return this.race.entries.map((entry) => {
        return {name: entry.creator.display_name, id: entry.creator.twitch_id}
      })
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
  name: 'race-streams',
  props: ['race']
}
