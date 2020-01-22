<template>
  <div style='margin: auto'>
    <vue-bootstrap-typeahead
      background-variant='dark'
      class="m-auto search"
      :data='gameResults.concat(userResults)'
      @hit='selectedItem = $event'
      placeholder='Search...'
      :serializer='item => item.name'
      text-variant='light'
      v-model='input'>
      <template v-slot:append v-if='loading'>
        <div class='input-group-append'>
          <div class='input-group-text'>
            <span class='spinner-border spinner-border-sm' role='status'>
              <span class='sr-only'>Loading...</span>
            </span>
          </div>
        </div>
      </template>
      <template slot="suggestion" slot-scope="{ data, htmlText }">
        <span v-html="htmlText"></span>
        <br />
        <small>{{ data.categories === undefined ? 'User' : `${data.categories.length} categories`}}</small>
      </template>
    </vue-bootstrap-typeahead>
  </div>
</template>

<script>
import VueBootstrapTypeahead from 'vue-bootstrap-typeahead'
const _ = require('underscore')

export default {
  components: {
    VueBootstrapTypeahead,
  },
  data: function() {
    return {
      gameResults: [],
      input: '',
      loading: false,
      selectedItem: null,
      userResults: [],
    }
  },
  methods: {
    debouncedFetch: _.debounce(async function(newQuery) {
      Promise.all([
        fetch(`/api/v4/games?search=${newQuery}`).then(response => response.json()).then(body => {
          this.gameResults = body.games
        }),
        fetch(`/api/v4/runners?search=${newQuery}`).then(response => response.json()).then(body => {
          this.userResults = body.runners
        }),
      ]).then(() => this.loading = false)
    }, 500),
  },
  watch: {
    input: function(newInput) {
      if (newInput) {
        this.loading = true
        this.debouncedFetch(newInput)
      }
    },
    selectedItem: function(newSelectedItem) {
      if (newSelectedItem.categories !== undefined) {
        Turbolinks.visit(`/games/${newSelectedItem.shortname}`)
      } else {
        Turbolinks.visit(`/users/${newSelectedItem.name}`)
      }
    },
  },
}
</script>
