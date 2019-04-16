const accessTokenKey = 'splitsio_access_token'
const accessTokenExpiryKey = 'splitsio_access_token_expiry'

const urlHashToObject = function(hash) {
  const params = {}
  hash.substring(1).split('&').map(hk => params[hk.split('=')[0]] = hk.split('=')[1])
  return params
}

document.addEventListener('turbolinks:load', () => {
  // Protect dev modes that haven't set up a client yet
  if (process.env.SPLITSIO_CLIENT_ID === undefined || gon.user === null) {
    return
  }

  // Fetch or refresh the access token if needed.
  const now = new Date()
  const accessToken = localStorage.getItem(accessTokenKey)
  const accessTokenExpiry = localStorage.getItem(accessTokenExpiryKey)
  const expiry = Date.parse(accessTokenExpiry)

  if (accessToken === null || accessTokenExpiry === null || isNaN(expiry)) {
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
    scope: 'upload_run',
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

    localStorage.setItem(accessTokenKey, hash.access_token)
    localStorage.setItem(accessTokenExpiryKey, expiry)
    document.body.removeChild(iframe)
  }
})
