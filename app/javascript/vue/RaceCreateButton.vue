<template>
  <div class="btn-group" v-cloak>
    <button class="btn btn-success" :content="error" :disabled="loading" @click="createPublic" type="button" v-tippy>
      <span v-cloak v-if="loading"><Spinner /></span>
      <span class="text-danger" v-cloak v-else-if="error"><i class="fas fa-exclamation-triangle" /></span>
      <span v-else><i class="fas fa-flag-checkered" /></span>
      Create race
    </button>
    <button class="btn btn-success dropdown-toggle dropdown-toggle-split" type="button"
            data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" v-if="!loading">
      <span class="sr-only">Toggle dropdown</span>
      <div class="dropdown-menu">
        <button class="dropdown-item" @click="createPublic">Create public race (default)</button>
        <button class="dropdown-item" @click="createInviteOnly">Create invite-only race</button>
        <button class="dropdown-item" @click="createSecret">Create secret race</button>
      </div>
    </button>
  </div>
</template>

<script>
import { getAccessToken } from '../token'
import Spinner from './Spinner.vue'

export default {
  components: {
    Spinner,
  },
  data: () => ({
    error: null,
    loading: false,
  }),
  methods: {
    createPublic: async function() {
      return this.create('public')
    },
    createSecret: async function() {
      return this.create('secret')
    },
    createInviteOnly: async function() {
      return this.create('invite_only')
    },
    create: async function(visibility) {
      try {
        this.loading = true
        this.error = null

        const headers = new Headers()
        headers.append('Content-Type', 'application/json')
        const accessToken = getAccessToken()
        if (accessToken) {
          headers.append('Authorization', `Bearer ${accessToken}`)
        }

        const response = await fetch(`/api/v4/races`, {
          method: 'POST',
          headers: headers,
          body: JSON.stringify({
            game_id: this.gameId,
            category_id: this.categoryId,
            visibility: visibility,
          })
        })

        if (!response.ok) {
          throw (await response.json()).error || response.statusText
        }

        window.location = (await response.json()).race.path
      } catch(error) {
        this.loading = false
        this.error = `Error: ${error}`
      }
    },
  },
  name: 'RaceCreateButton',
  props: ['game-id', 'category-id'],
}
</script>
