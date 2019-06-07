export default {
  data: () => ({
    body: '',
    error: null,
    loading: false,
  }),
  methods: {
    chat: async function() {
      fetch(`/api/v4/${this.raceable.type}s/${this.raceable.id}/chat`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('splitsio_access_token')}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          body: this.body,
        })
      })
    },
  },
  name: 'race-chat',
  props: ['raceable'],
}
