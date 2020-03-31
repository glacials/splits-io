const hotsauceKey = 'hotsauce2020_redirected'
document.addEventListener('turbolinks:load', function() {
  if (localStorage.getItem(hotsauceKey) === '1') {
    return
  }

  const now = new Date()
  if (now.getMonth() === 3 && now.getDate() === 1) {
    localStorage.setItem(hotsauceKey, '1')
    window.location = '/hot#sauce'
  }
})

document.addEventListener('click', async function(event) {
  const hotsauceButton = event.target.closest('.hotsauce-buy')
  if (hotsauceButton === null) {
    return
  }

  event.preventDefault()

  const stripe = Stripe(process.env.STRIPE_PUBLISHABLE_KEY)
  stripe.redirectToCheckout({
    items: [{sku: hotsauceButton.dataset.sku, quantity: 1}],
    successUrl: 'https://splits.io/hot?ordered=1#sauce',
    cancelUrl: 'https://splits.io/hot?ordered=0#sauce',
    clientReferenceId: gon.user && gon.user.id,
    customerEmail: gon.user && gon.user.email,
    shippingAddressCollection: {
      allowedCountries: ['US'],
    },
  })
})
