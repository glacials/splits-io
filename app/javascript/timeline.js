import Highcharts from 'highcharts'

document.addEventListener('mouseover', event => {
  const segment = event.target.closest('.split')
  if (segment === null) {
    return
  }

  const id = segment.id.split('-')
  document.getElementById(`${id[0]}-inspect-${id[2]}`).style.visibility = 'visible'
})

document.addEventListener('mouseout', event => {
  const segment = event.target.closest('.split')
  if (segment === null) {
    return
  }

  const id = segment.id.split('-')
  document.getElementById(`${id[0]}-inspect-${id[2]}`).style.visibility = 'hidden'
})
