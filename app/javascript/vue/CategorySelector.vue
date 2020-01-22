<template>
  <select class='form-control' v-model='selectedCategoryId' v-if='game' name='run[category]'>
    <option v-if='nullCategory' :value='null'>
      {{nullCategory}}
    </option>
    <option v-for='category in game.categories' :value='category.id'>
      {{category.name}}
    </option>
  </select>
</template>

<script>
export default {
  data: function () {
    return {
      selectedCategoryId: this.value && this.value.id,
    }
  },
  props: ['game', 'value', 'null-category'],
  watch: {
    game: function (newGame) {
      if (!this.selectedCategoryId) {
        return
      }

      if (newGame.categories.find(category => category.id === this.selectedCategoryId)) {
        return
      }

      if (!this.nullCategory && !this.selectedCategoryId) {
        this.selectedCategoryId = newGame.categories[0].id
        return
      }

      this.selectedCategoryId = this.nullCategory ? null : newGame.categories[0].id
    },
    selectedCategoryId: function(newSelectedCategoryId) {
      this.$emit('input', this.game.categories.find(category => category.id === newSelectedCategoryId) || null)
    },
    value: function(newCategory) {
      this.selectedCategoryId = newCategory.id
    }
  },
}
</script>
