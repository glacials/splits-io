import _ from 'underscore'

const upload = function(file, options) {
  if(file === undefined) {
    document.getElementById('droplabel').textContent = 'That looks like an empty file! :('
    window.isUploading = false
    window.spinner.stop()
    return
  }
  options = Object.assign({bulk: false}, options)
  return fetch('/api/v4/runs', {method: 'POST', credentials: 'include'}).then(function(splitsioResponse) {
    return splitsioResponse.json()
  }).then(function(splitsioResponse) {
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
        window.location = '/cant-parse'
      }

      if(!options.bulk) {
        document.getElementById('droplabel').textContent = 'Parsing...'
        window.location = splitsioResponse.uris.claim_uri
      }
    }).catch(function(error) {
      // If we are bulk uploading, let the uploadAll function handle the error
      if(options.bulk) {
        throw error
      }
      window.isUploading = false
      document.getElementById('droplabel').innerHTML = `Error: ${error.message}.<br />Try again, or email help@splits.io!<br />`
      window.spinner.stop()
    })
  })
}

const uploadAll = function(files) {
  document.getElementById('multiupload').style.visibility = 'visible'
  Promise.all(files.map(function(file) {
    return new Promise(function(resolve, reject) {
      upload(file, {bulk: true}).then(function() {
        const newTotal = Number(document.getElementById('successful-uploads').textContent) + 1
        document.getElementById('successful-uploads').textContent = newTotal
        resolve()
      }).catch(function(error) {
        const newTotal = Number(document.getElementById('failed-uploads').textContent) + 1
        document.getElementById('failed-uploads').textContent = newTotal
        resolve()
      })
    })
  })).then(function() {
    document.getElementById('droplabel').textContent = 'Parsing...'
    window.location = "/"
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
      document.getElementById('droplabel').textContent = 'To upload more than one file at a time, please sign in.'
      return
    }

    document.getElementById('droplabel').textContent = 'Uploading...'
    window.isUploading = true
    window.showSpinner('#fff')

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
    window.showSpinner("#000")
    window.isUploading = true
    upload(document.getElementById('file').files[0])
  })
})
