const accessTokenKey = 'splitsio_access_token'
const accessTokenExpiryKey = 'splitsio_access_token_expiry'
const returnToKey = 'return_to'

const urlHashToObject = function(hash) {
  const params = {}
  hash.substring(1).split('&').map(hk => params[hk.split('=')[0]] = hk.split('=')[1])
  return params
}
  
document.addEventListener('turbolinks:load', () => {
  // Protect dev modes that haven't set up a client yet
  if (process.env.SPLITSIO_CLIENT_ID === undefined) {
    return
  }

  if (window.location.pathname === '/auth/splitsio/callback') {
    const hash = urlHashToObject(window.location.hash)
    const expiry = new Date()
    expiry.setSeconds(expiry.getSeconds() + Number(hash.expires_in))

    localStorage.setItem(accessTokenKey, hash.access_token)
    localStorage.setItem(accessTokenExpiryKey, expiry)

    const returnTo = localStorage.getItem(returnToKey)
    localStorage.removeItem(returnToKey)
    window.location = returnTo
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

  // If the token expires in the next 5 minutes
  if (localStorage.getItem(accessTokenExpiryKey) === null || (expiry - now) / (1000 * 60) <= 5) {
    params = {
      response_type: 'token',
      scope: 'upload_run',
      redirect_uri: `${window.location.origin}/auth/splitsio/callback`,
      client_id: process.env.SPLITSIO_CLIENT_ID
    }
    localStorage.setItem(returnToKey, window.location.pathname)
    window.location = `/oauth/authorize?${Object.keys(params).map(k => `${k}=${params[k]}`).join('&')}`
  }
})
