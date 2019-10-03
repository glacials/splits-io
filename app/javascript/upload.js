import _ from 'underscore'
import { getAccessToken } from './token'
import waitForRunsToParse from './run_parse.js'

const upload = async function(file, options) {
  if(file === undefined) {
    document.getElementById('droplabel').textContent = 'That file looks empty 😕'
    window.isUploading = false
    document.getElementById('upload-spinner').hidden = true
    return
  }
  options = Object.assign({bulk: false}, options)

  const headers = new Headers()
  headers.append('Content-Type', 'application/json')
  const accessToken = getAccessToken()
  if (accessToken) {
    headers.append('Authorization', `Bearer ${accessToken}`)
  }

  const splitsioResponse = await fetch('/api/v4/runs', {
    method: 'POST',
    headers: headers,
  }).then(r => r.json())
  const formData = new FormData()
  for(const [k, v] of Object.entries(splitsioResponse.presigned_request.fields)) {
    formData.append(k, v)
  }
  formData.append('file', file)

  return fetch(splitsioResponse.presigned_request.uri, {
    method: splitsioResponse.presigned_request.method,
    body: formData
  }).then(function(s3Response) {
    if(s3Response.status === 400 && !options.bulk) {
      Turbolinks.visit('/cant-parse')
    }
    document.getElementById('droplabel').textContent = 'Uploading'

    if(!options.bulk) {
      Turbolinks.visit(splitsioResponse.uris.claim_uri)
    } else {
      return splitsioResponse.id
    }
  }).catch(function(error) {
    // If we are bulk uploading, let the uploadAll function handle the error
    window.isUploading = false
    document.getElementById('droplabel').innerHTML = `Error: ${error.message}.<br />Try again, or email help@splits.io!<br />`
    document.getElementById('upload-spinner').hidden = true
    throw error
  })
}

// Reset the dropzone whenever we change pages, otherwise it will stay visible through Turbolinks.visits
document.addEventListener('turbolinks:load', function() {
  document.getElementById('dropzone-overlay').style.visibility = 'hidden'
  document.getElementById('droplabel').textContent = 'Waiting for drop'
  document.getElementById('multiupload').style.visibility = 'hidden'
})

const uploadAll = function(files) {
  document.getElementById('multiupload').style.visibility = 'visible'

  Promise.all(files.map(file => new Promise((resolve, reject) => {
    upload(file, {bulk: true}).then(runId => {
      const newTotal = Number(document.getElementById('successful-uploads').textContent) + 1
      document.getElementById('successful-uploads').textContent = newTotal
      resolve(runId)
    }).catch(error => {
      const newTotal = Number(document.getElementById('failed-uploads').textContent) + 1
      document.getElementById('failed-uploads').textContent = newTotal
      console.error(error)
      resolve()
    })
  }))).then(runIds => {
    waitForRunsToParse(runIds).then(() => Turbolinks.visit('/'), () => Turbolinks.visit('/'))
  })
}

document.addEventListener('turbolinks:load', function() {
  // Show dropzone-overlay when a file is dragged onto the page
  if (document.getElementById('dropzone') === null) {
    return
  }

  document.getElementById('dropzone').addEventListener('dragenter', function(event) {
    event.preventDefault()
    event.stopPropagation()
    document.getElementById('dropzone-overlay').style.visibility = 'visible'
  })

  // Hide dropzone-overlay when a file is dragged off of the page
  document.getElementById('dropzone').addEventListener('dragleave', function(event) {
    if(event.pageX < 10 || event.pageY < 10 || window.innerWidth - event.pageX < 10 || window.innerHeight - event.pageY < 10) {
      document.getElementById('dropzone-overlay').style.visibility = 'hidden'
    }
  })

  document.getElementById('dropzone').addEventListener('dragover', function(event) {
    event.preventDefault()
    event.stopPropagation()
  })

  // Upload when a file is dropped onto the page
  document.getElementById('dropzone').addEventListener('drop', function(event) {
    event.preventDefault()
    event.stopPropagation()

    const files = event.dataTransfer.files
    if (files.length > 1 && gon.user === null) {
      document.getElementById('droplabel').textContent = 'Please sign in to bulk-upload runs'
      return
    }

    document.getElementById('droplabel').textContent = 'Uploading'
    window.isUploading = true
    document.getElementById('upload-spinner').hidden = false

    if (files.length > 1) {
      uploadAll(_.toArray(files))
    } else {
      upload(files[0])
    }
  })

  // If we left dropzone-overlay open to show an error, dismiss it when clicked on
  document.getElementById('dropzone').addEventListener('click', function(event) {
    if(!window.isUploading) {
      document.getElementById('dropzone-overlay').style.visibility = 'hidden'
    }
  })

  // If we left dropzone-overlay open to show an error, dismiss it when ESC is pressed
  document.addEventListener('keyup', function(event) {
    if(event.keyCode === 27 && !window.isUploading) {
      document.getElementById('dropzone-overlay').style.visibility = 'hidden'
    }
  })
})

document.addEventListener('turbolinks:load', function() {
  const form = document.getElementById('upload')
  if(form === null) {
    return
  }

  form.addEventListener('change', function() {
    document.getElementById('upload-spinner').hidden = false
    window.isUploading = true
    upload(document.getElementById('file').files[0])
  })
})
