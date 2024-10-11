<template>
  <div>
    <vue-bootstrap-autocomplete
      background-variant="dark"
      class="mb-1"
      :data="gameResults"
      @hit="$emit('input', $event)"
      :placeholder="(value && value.name) || 'Start typing to choose a game...'"
      :serializer="(game) => game.name"
      text-variant="light"
      v-model="input"
    >
      <template v-slot:append v-if="loading">
        <div class="input-group-append">
          <div class="input-group-text">
            <span class="spinner-border spinner-border-sm" role="status">
              <span class="sr-only">Loading...</span>
            </span>
          </div>
        </div>
      </template>
    </vue-bootstrap-autocomplete>
  </div>
</template>

<script>
import VueBootstrapAutocomplete from "@vue-bootstrap-components/vue-bootstrap-autocomplete";
const _ = require("underscore");

export default {
  components: {
    VueBootstrapAutocomplete,
  },
  data: function () {
    return {
      gameResults: [],
      input: this.value && this.value.name,
      loading: false,
    };
  },
  methods: {
    debouncedFetch: _.debounce(async function (newGame) {
      const body = await fetch(`/api/v4/games?search=${newGame}`).then(
        (response) => response.json()
      );
      this.gameResults = body.games;
      this.loading = false;
    }, 500),
  },
  props: ["value"],
  watch: {
    input: function (newGame) {
      if (newGame) {
        this.loading = true;
        this.debouncedFetch(newGame);
      }
    },
  },
};
</script>
