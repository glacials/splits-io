const surveyKey = 'survey2019'

document.addEventListener('turbolinks:load', () => {
  if (localStorage.getItem(surveyKey) === 'hide') {
    return
  }

  document.getElementById('survey-container').style.display = 'block'
})

document.addEventListener('click', event => {
  if (event.target.closest('#survey-button') === null) {
    return
  }

  localStorage.setItem(surveyKey, 'hide')
})

document.addEventListener('click', event => {
  if (event.target.closest('#hide-survey-button') === null) {
    return
  }

  localStorage.setItem(surveyKey, 'hide')
  document.getElementById('survey-container').style.display = 'none'
})
