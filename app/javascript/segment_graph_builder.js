import {build_segment_graph} from "graphs/segment_duration_graph.js"
import {Spinner} from 'spin.js'

document.addEventListener('turbolinks:load', function() {
  const graphHolders = document.getElementsByClassName('segment-graph-holder')
  if(graphHolders.length === 0) {
    return
  }

  const spinners = []

  for(const graphHolder of graphHolders) {
    const spinner = new Spinner({
      lines: 3,
      length: 15,
      width: 1,
      radius: 0,
      corners: 1,
      rotate: 90,
      direction: 1,
      color: '#FFFFFF',
      speed: 0.5,
      trail: 30,
      shadow: false,
      hwaccel: true,
      position: 'relative'
    })
    spinner.spin(graphHolder)
    spinners.push(spinner)
  }

  const runJSON = fetch(`/api/v4/runs/${gon.run.id}?historic=1`, {
    headers: {
      accept: 'application/json'
    }
  }).then(function(response) {
    if (response.ok) {
      return response.json()
    }
    throw new Error('Request for run from api failed')
  })

  runJSON.then(function(json) {
    spinners.forEach(function(spinner) {
      spinner.stop()
    })
  }).catch(function(error) {
    spinners.forEach(function(spinner) {
      spinner.stop()
    })
    for(const graphHolder of document.getElementsByClassName('graph-holder')) {
      graphHolder.find('.panel-title').find('h1').text('Error retrieving data for graphs')
    }
  })

  if (gon.run.timer === 'livesplit') {
    for (const toggler of document.getElementsByClassName('segment-graph-toggler')) {
      toggler.addEventListener('click', function(event) {
        event.preventDefault()
        const row = document.querySelector(
          `.segment-graph-holder[data-segment="${toggler.dataset.segment}"]`
        ).closest('tr')
        row.hidden = !row.hidden
        if (event.target.dataset.generated !== '1') {
          event.target.dataset.generated = '1'
          runJSON.then(function(json) {
            const segment = json.run.segments.filter(segment => (segment.id === toggler.dataset.segment))[0]
            build_segment_graph(segment)
          })
        }
      })
    }
  }
})
