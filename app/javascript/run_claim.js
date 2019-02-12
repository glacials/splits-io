// Format of possible localStorage values is:
//
// Standard Claim Token -- a run uploaded while not logged in
// "claim_tokens/<run_id>": "<claim_token>"
// e.g. "claim_tokens/gcb": "wYJm4S9uAAra6TMyzLkvhC5y"
//
// Dismissed Claim Token -- a Standard Claim Token whose prompt was dismised in the UI 
// "dismissed_claim_tokens/<run_id>": "<claim_token>"
// e.g. "dismissed_claim_tokens/gcb": "wYJm4S9uAAra6TMyzLkvhC5y"

const activateClaimLink = function(claimToken) {
  if(gon.user !== null) {
    document.getElementById('claim-nav-link').href = `/${gon.run.id}?claim_token=${claimToken}`
  }

  document.getElementById('claim-nav-link-container').hidden = false
}

const activateClaimPrompt = function(claimToken) {
  if(gon.user !== null) {
    document.getElementById('claim-prompt-button').href = `/${gon.run.id}?claim_token=${claimToken}`
  }

  document.getElementById('claim-prompt').hidden = false
}

document.addEventListener('turbolinks:load', function() {
  if(gon.run === undefined || location.pathname.substr(location.pathname.lastIndexOf('/')) === '/edit') {
    return
  }

  if (location.pathname === '/') {
    return
  }

  const claimTokenKey = `claim_tokens/${gon.run.id}`
  const dismissedClaimTokenKey = `dismissed_claim_tokens/${gon.run.id}`

  // If there's a claim token in the URL, slurp it up into local storage and remove it from the URL.
  const queryParams = new URLSearchParams(window.location.search)
  if(queryParams.has('claim_token')) {
    localStorage.setItem(claimTokenKey, queryParams.get('claim_token'))
    queryParams.delete('claim_token')

    // Clean up the URL
    if(queryParams.toString() === '') {
      window.history.replaceState({}, document.title, window.location.pathname)
    } else {
      window.history.replaceState({}, document.title, `${window.location.pathname}?${queryParams.toString()}`)
    }
  }

  document.getElementById('dismiss-claim-prompt').addEventListener('click', function() {
    document.getElementById('claim-prompt').hidden = true
    localStorage.removeItem(claimTokenKey)
    localStorage.setItem(dismissedClaimTokenKey, claimToken)
  })

  // When a run is claimed, the backend prevents it from ever being claimed again, even if the run is later disowned. So
  // let's get rid of our useless claim token.
  if(gon.run.user !== null) {
    localStorage.removeItem(claimTokenKey)
    localStorage.removeItem(dismissedClaimTokenKey)
    return
  }

  const claimToken = localStorage.getItem(claimTokenKey)
  const dismissedClaimToken = localStorage.getItem(dismissedClaimTokenKey)

  if(claimToken !== null) {
    activateClaimLink(claimToken)
    activateClaimPrompt(claimToken)
    return
  }

  if(dismissedClaimToken !== null) {
    activateClaimLink(dismissedClaimToken)
    return
  }
})
