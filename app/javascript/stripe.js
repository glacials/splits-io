document.addEventListener('click', async function(event) {
  const subscribeButton = event.target.closest('.stripe-checkout')
  if (subscribeButton === null) {
    return
  }

  event.preventDefault()

  const coupon = new URL(document.URL).searchParams.get('coupon')

  const stripe = Stripe(process.env.STRIPE_PUBLISHABLE_KEY)
  const result = await stripe.redirectToCheckout({
    items: [{plan: subscribeButton.dataset.planId, quantity: 1}],
    successUrl: `${location.origin}/subscriptions/success?session_id={CHECKOUT_SESSION_ID}&coupon=${coupon}`,
    cancelUrl: `${location.origin}/subscriptions/cancel`,
    clientReferenceId: gon.user.id,
    customerEmail: gon.user.email,
  })

  if (result.error) {
    document.getElementById('error-message').textContent = result.error.message;
  }
})
