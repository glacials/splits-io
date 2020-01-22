<template>
  <div class='form-row'>
    <div class='col-md-12 my-1'>
      <label for='game-selector'>Game</label>
      <GameSelector v-model='selectedGame' />
      <label for='category-selector'>Category</label>
      <CategorySelector v-model='selectedCategory' :game='selectedGame' />
    </div>
  </div>
</template>

<script>
import GameSelector from './GameSelector.vue'
import CategorySelector from './CategorySelector.vue'

export default {
  components: {
    GameSelector,
    CategorySelector,
  },
  created: async function () {
    this.run = (await fetch(`/api/v4/runs/${this.runId}`).then(response => response.json())).run
    this.selectedGame = (await fetch(`/api/v4/games?search=${this.run.game.id}`).then(response => response.json())).games[0]
    this.selectedCategory = this.run.category
  },
  data: function () {
    return {
      run: null,
      selectedCategory: null,
      selectedGame: null,
    }
  },
  props: ['run-id'],
}
</script>
