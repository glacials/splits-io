import consumer from '../../consumer'

let globalSubscription

document.addEventListener('turbolinks:load', () => {
  globalSubscription = consumer.subscriptions.create('Api::V1::GlobalRaceChannel', {
    connection() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      switch(data.type) {
        case 'race_creation_success':
          Turbolinks.visit(data.data.path)
          break
        case 'race_creation_error':
          // TODO some kind of error handling
          break
      }
    },

    createStandard(categoryId, visibility, notes) {
      this.perform('create_race', {
        race_type: 'race',
        category_id: categoryId,
        visibility: visibility,
        notes: notes
      })
    },

    createBingo(gameId, visibility, notes, card) {
      this.perform('create_race', {
        race_type: 'bingo',
        game_id: gameId,
        visibility: visibility,
        notes: notes,
        bingo_card: card
      })
    },

    createRandomizer(gameId, visibility, notes, seed) {
      this.perform('create_race', {
        race_type: 'randomizer',
        game_id: gameId,
        visibility: visibility,
        notes: notes,
        seed: seed
      })
    }
  })
}, {once: true})

document.addEventListener('click', (event) => {
  if (event.target.matches('#standard-submit')) {
    const categorySelect = document.getElementById('standard-category-select')
    const visibilitySelect = document.getElementById('standard-visibility-select')
    const notesTextArea = document.getElementById('standard-notes-textarea')
    globalSubscription.createStandard(
      categorySelect.selectedOptions[0].value,
      visibilitySelect.selectedOptions[0].value,
      notesTextArea.value
    )
  }

  if (event.target.matches('#bingo-submit')) {
    const gameIdInput = document.getElementById('bingo-game-id')
    const visibilitySelect = document.getElementById('bingo-visibility-select')
    const notesTextArea = document.getElementById('bingo-notes-textarea')
    const bingoInput = document.getElementById('bingo-card-input')
    globalSubscription.createBingo(
      gameIdInput.value,
      visibilitySelect.selectedOptions[0].value,
      notesTextArea.value,
      bingoInput.value
    )
  }

  if (event.target.matches('#randomizer-submit')) {
    const gameIdInput = document.getElementById('bingo-game-id')
    const visibilitySelect = document.getElementById('standard-visibility-select')
    const notesTextArea = document.getElementById('standard-notes-textarea')
    const seedInput = document.getElementById('randomizer-seed-input')
    globalSubscription.createRandomizer(
      gameIdInput.value,
      visibilitySelect.selectedOptions[0].value,
      notesTextArea.value,
      seedInput.value
    )
  }
})
