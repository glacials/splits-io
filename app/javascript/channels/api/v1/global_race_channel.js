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
        case 'fatal_error':
          // TODO consolodate this with `createAlert` in races_channel.js
          const div = document.createElement('div')
          div.classList = `alert alert-danger center`
          div.setAttribute('role', 'alert')
          div.innerText = `Error: ${data.data.message}`
          document.getElementById('alerts').appendChild(div)
          setTimeout(() => { div.parentNode.removeChild(div) }, 5000)
          break
      }
    },

    createRace(categoryId, visibility, notes) {
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
  if (event.target.matches('#category-submit')) {
    const categorySelect = document.getElementById('category-select')
    const visibilitySelect = document.getElementById('visibility-select')
    const notesTextArea = document.getElementById('notes-textarea')
    globalSubscription.createRace(
      categorySelect.selectedOptions[0].value,
      visibilitySelect.selectedOptions[0].value,
      notesTextArea.value
    )
  }

  if (event.target.matches('#bingo-submit')) {
    const gameIdInput = document.getElementById('game-id')
    const visibilitySelect = document.getElementById('visibility-select')
    const notesTextArea = document.getElementById('notes-textarea')
    const bingoInput = document.getElementById('bingo-card-input')

    if (bingoInput.value === '') {
      bingoInput.classList.add('is-invalid')
      return
    }

    globalSubscription.createBingo(
      gameIdInput.value,
      visibilitySelect.selectedOptions[0].value,
      notesTextArea.value,
      bingoInput.value
    )
  }

  if (event.target.matches('#randomizer-submit')) {
    const gameIdInput = document.getElementById('game-id')
    const visibilitySelect = document.getElementById('visibility-select')
    const notesTextArea = document.getElementById('notes-textarea')
    const seedInput = document.getElementById('randomizer-seed-input')

    if (seedInput.value === '') {
      seedInput.classList.add('is-invalid')
      return
    }

    globalSubscription.createRandomizer(
      gameIdInput.value,
      visibilitySelect.selectedOptions[0].value,
      notesTextArea.value,
      seedInput.value
    )
  }
})
