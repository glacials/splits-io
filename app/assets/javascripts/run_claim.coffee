# Format of possible localStorage values is:
#
# Standard Claim Token -- a run uploaded while not logged in
# "claim_tokens/<run_id>": "<claim_token>"
# e.g. "claim_tokens/gcb": "wYJm4S9uAAra6TMyzLkvhC5y"
#
# Dismissed Claim Token -- a Standard Claim Token whose prompt was dismised in the UI 
# "dismissed_claim_tokens/<run_id>": "<claim_token>"
# e.g. "dismissed_claim_tokens/gcb": "wYJm4S9uAAra6TMyzLkvhC5y"

activateClaimLink = (claimToken) ->
  if gon.user != null
    claimLink = document.getElementById('claim-nav-link')
    claimLink.href = '/' + gon.run.id + '?claim_token=' + claimToken

  claimLinkContainer = document.getElementById('claim-nav-link-container')
  claimLinkContainer.style.display = 'inline'

activateClaimPrompt = (claimToken) ->
  if gon.user != null
    claimPromptButton = document.getElementById('claim-prompt-button')
    claimPromptButton.href = '/' + gon.run.id + '?claim_token=' + claimToken

  claimPrompt = document.getElementById('claim-prompt')
  claimPrompt.style.display = 'block'

$ ->
  if gon.run == undefined
    return

  claimTokenKey = 'claim_tokens/' + gon.run.id
  dismissedClaimTokenKey = 'dismissed_claim_tokens/' + gon.run.id

  if gon.run.user != null
    localStorage.removeItem(dismissedClaimTokenKey)
    localStorage.removeItem(claimTokenKey)
    return

  claimToken = localStorage.getItem(claimTokenKey)
  dismissedClaimToken = localStorage.getItem(dismissedClaimTokenKey)

  document.getElementById('dismiss-claim-prompt').addEventListener 'click', ->
    document.getElementById('claim-prompt').style.display = 'none'
    localStorage.removeItem(claimTokenKey)
    localStorage.setItem(dismissedClaimTokenKey, claimToken)

  if claimToken != null
    activateClaimLink(claimToken)
    activateClaimPrompt(claimToken)
    return

  if dismissedClaimToken != null
    activateClaimLink(dismissedClaimToken)
    return
