<template>
  <div>
    <select
      class="form-control"
      id="category-selector"
      v-model="selectedCategoryId"
      v-if="game"
      name="run[category]"
    >
      <option v-if="nullCategory" :value="null">
        {{ nullCategory }}
      </option>
      <option
        v-for="category in game.categories"
        v-bind:key="category.id"
        :value="category.id"
      >
        <span v-if="category.srdc_id">✓</span>
        {{ category.name }}
      </option>
    </select>
    <small>✓ = Synced with speedrun.com</small>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      selectedCategoryId: this.value && this.value.id,
    }
  },
  props: ["game", "value", "null-category"],
  watch: {
    game: function (newGame) {
      newGame.categories.sort((a, b) => {
        if (a.srdc_id && !b.srdc_id) {
          return -1
        }

        if (!a.srdc_id && b.srdc_id) {
          return 1
        }

        if (Date.parse(a.updated_at) > Date.parse(b.updated_at)) {
          return -1
        }

        return 1
      })

      if (!this.selectedCategoryId) {
        return
      }

      if (
        newGame.categories.find(
          (category) => category.id === this.selectedCategoryId
        )
      ) {
        return
      }

      if (!this.nullCategory && !this.selectedCategoryId) {
        this.selectedCategoryId = newGame.categories[0].id
        return
      }

      this.selectedCategoryId = this.nullCategory
        ? null
        : newGame.categories[0].id
    },
    selectedCategoryId: function (newSelectedCategoryId) {
      this.$emit(
        "input",
        this.game.categories.find(
          (category) => category.id === newSelectedCategoryId
        ) || null
      )
    },
    value: function (newCategory) {
      this.selectedCategoryId = newCategory.id
    },
  },
};
</script>
