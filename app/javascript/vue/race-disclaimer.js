export default {
  data: () => ({
    accepted: false,
  }),
  methods: {
    accept: function() {
      this.accepted = true
    }
  },
  name: 'race-disclaimer',
}
