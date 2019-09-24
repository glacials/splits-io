document.addEventListener('click', async function(event) {
  const subscribeButton = event.target.closest('.stripe-checkout')
  if (subscribeButton === null) {
    return
  }

  event.preventDefault()

  const stripe = Stripe('pk_live_VfM5KQUFsv9409VUuxWjTSum') // TODO: Use process.env.STRIPE_PUBLISHABLE_KEY once it's accessible from webpack (it is in dev, not in prod)
  const result = await stripe.redirectToCheckout({
    items: [{plan: subscribeButton.dataset.planId, quantity: 1}],
    successUrl: `${location.origin}/subscriptions/success?session_id={CHECKOUT_SESSION_ID}`,
    cancelUrl: `${location.origin}/subscriptions/cancel`,
    clientReferenceId: gon.user.id,
    customerEmail: gon.user.email,
  })

  if (result.error) {
    document.getElementById('error-message').textContent = result.error.message;
  }
})
