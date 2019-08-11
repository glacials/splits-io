const surveyKey = 'survey2019'
const firstVisitKey = 'firstVisit2019'

document.addEventListener('turbolinks:load', () => {
  if (localStorage.getItem(surveyKey) === 'hide') {
    return
  }

  // Don't show the survey link to new users, as it's useless for them & distracts from learning about the website
  if (localStorage.getItem(firstVisitKey) === null) {
    localStorage.setItem(firstVisitKey, new Date)
    return
  } else {
    const d = new Date(localStorage.getItem(firstVisitKey))
    d.setMonth(d.getMonth() + 1)
    if (d > new Date()) {
      return
    }
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
