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
    },

    getBreakPointDiv: function(desiredBreak) {
      const breakPointDiv = document.createElement('div')
      const allSizes = ['sm', 'md', 'lg', 'xl']
      const breakpoints = allSizes.map(size => size === desiredBreak ? `d-${size}-block` : `d-${size}-none`)
      breakpoints.unshift(desiredBreak === 'xs' ? 'd-block' : 'd-none')
      breakPointDiv.className = `w-100 ${breakpoints.join(' ')}`
      return breakPointDiv
    }
  },

  updated: function() {
    const deck = document.getElementById('stream-deck')
    if (!deck) {
      return
    }

    // We have to manually add and remove breakpoints in JS otherwise we cannot utilize :key on the card div
    // Without :key all iframes after the removed one will reload
    deck.querySelectorAll('#stream-deck .w-100').forEach(breakpoint => {
      breakpoint.parentNode.removeChild(breakpoint)
    })

    deck.querySelectorAll('.card').forEach((card, i) => {
      deck.insertBefore(this.getBreakPointDiv('xs'), card.nextSibling)
      if (i + 1 === 2) { deck.insertBefore(this.getBreakPointDiv('md'), card.nextSibling) }
      if (i + 1 === 3) { deck.insertBefore(this.getBreakPointDiv('lg'), card.nextSibling) }
      if (i + 1 === 4) { deck.insertBefore(this.getBreakPointDiv('xl'), card.nextSibling) }
    })

    // Resize iframe divs in their dynamic column/rows
    document.querySelectorAll('.twitch-stream').forEach(div => {
      const iframe = div.firstChild
      iframe.height = this.ratioHeight(div)
    })
  },
  name: 'race-streams',
  props: ['race']
}
