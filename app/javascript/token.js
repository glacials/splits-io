import consumer from 'channels/consumer'

const accessTokenKey = 'splitsio_access_token'
const accessTokenExpiryKey = 'splitsio_access_token_expiry'

const urlHashToObject = function(hash) {
  const params = {}
  hash.substring(1).split('&').map(hk => params[hk.split('=')[0]] = hk.split('=')[1])
  return params
}

// Returns undefined if token is not set, null if expired, or the token as a string
const getAccessToken = function() {
  const accessToken = localStorage.getItem(accessTokenKey)
  const expireTime  = localStorage.getItem(accessTokenExpiryKey)
  if (accessToken === undefined || expireTime === undefined) {
    return undefined
  }

  if (new Date() > new Date(expireTime)) {
    // If the token is expired return null to indicate the token shouldn't be used
    return null
  }

  return accessToken
}

document.addEventListener('turbolinks:load', () => {
  // Protect dev modes that haven't set up a client yet
  if (process.env.SPLITSIO_CLIENT_ID === undefined) {
    console.warn("SPLITSIO_CLIENT_ID & SPLITSIO_CLIENT_SECRET not set in .envrc. Some features like races won't work.")
  }
  if (!gon.user) {
    localStorage.removeItem(accessTokenKey)
    localStorage.removeItem(accessTokenExpiryKey)
    return
  }

  // Fetch or refresh the access token if needed.
  const now = new Date()
  const accessToken = localStorage.getItem(accessTokenKey)
  const accessTokenExpiry = localStorage.getItem(accessTokenExpiryKey)
  const expiry = Date.parse(accessTokenExpiry)

  if (accessToken === null || accessTokenExpiry === null || isNaN(expiry) || accessToken === 'undefined') {
    localStorage.removeItem(accessTokenKey)
    localStorage.removeItem(accessTokenExpiryKey)
  }

  // Return if the token doesn't expire in the next 5 minutes
  if (localStorage.getItem(accessTokenExpiryKey) !== null && (expiry - now) / (1000 * 60) >= 5) {
    return
  }

  // Load the oauth document in an iframe and extract the token
  const iframe = document.createElement('iframe')
  const params = {
    response_type: 'token',
    scope: 'upload_run+manage_race',
    redirect_uri: `${window.location.origin}/auth/splitsio/callback`,
    client_id: process.env.SPLITSIO_CLIENT_ID
  }
  iframe.src = `/oauth/authorize?${Object.keys(params).map(k => `${k}=${params[k]}`).join('&')}`
  iframe.style.display = 'none'
  document.body.appendChild(iframe)
  iframe.onload = () => {
    const hash = urlHashToObject(iframe.contentWindow.location.hash)
    const expiry = new Date()
    expiry.setSeconds(expiry.getSeconds() + Number(hash.expires_in))

    if (accessToken === 'undefined') {
      console.warn("Can't get a Splits.io access token. Your SPLITSIO_CLIENT_ID/SPLITSIO_CLIENT_SECRET may be wrong.")
      return
    }

    localStorage.setItem(accessTokenKey, hash.access_token)
    localStorage.setItem(accessTokenExpiryKey, expiry)
    document.body.removeChild(iframe)
    consumer.connection.close()
    consumer.connection.open()
  }
})

// Add a hidden 'access_token' field to form.auth-me elements. The value is the browser's locally stored Splits.io
// access token.
document.addEventListener('turbolinks:load', () => {
  Array.from(document.querySelectorAll('form.auth-me')).forEach(el => {
    el.classList.remove('auth-me')

    const tokenField = document.createElement('input')
    tokenField.type = 'hidden'
    tokenField.name = 'access_token'
    tokenField.value = localStorage.getItem(accessTokenKey)
    el.appendChild(tokenField)
  })
})

export { getAccessToken }
