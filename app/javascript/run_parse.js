import consumer from './channels/consumer'

document.addEventListener('turbolinks:load', function() {
  const awaitRuns = document.getElementById('await-runs')
  if (awaitRuns === null) {
    return
  }

  waitForRunsToParse(awaitRuns.dataset.runs.split(',')).then(
    () => Turbolinks.visit(window.location),
    () => Turbolinks.visit('/cant-parse'),
  )
})

const waitForRunsToParse = function (runIds) {
  // Wait for all runs on this page to finish parsing, then refresh the page
  return Promise.all(runIds.map(runId => new Promise(async (resolve, reject) => {
    consumer.subscriptions.create({
      channel: 'Api::V4::RunChannel', 
      run_id: runId,
    }, {
      connection() {},

      disconnected() {},

      received(data) {
        switch(data.type) {
          case 'run_state':
            if (data.data.run.parsed_at) {
              // The run was already parsed while we were busy connecting to Action Cable
              resolve()
            }
            break
          case 'run_parsed':
            resolve()
            break
          case 'cant_parse_run':
            reject()
            break
          case 'run_not_found':
            reject()
            break
          default:
            console.log(JSON.stringify(data))
            reject()
            break
        }
      },
    })
  })))
}

export default waitForRunsToParse
