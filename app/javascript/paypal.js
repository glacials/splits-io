import { loadScript } from '@paypal/paypal-js'

document.addEventListener("turbolinks:load", function () {
  if (!document.getElementById('paypal-button-container')) {
    return false
  }

  loadScript({
    'client-id': process.env.PAYPAL_CLIENT_ID,
    'vault': 'true',
    'intent': 'subscription',
    'disable-funding': 'credit'
  }).then(() => {
    const buttons = paypal.Buttons({
      style: {
        shape: 'rect',
        color: 'gold',
        layout: 'horizontal',
        label: 'subscribe'
      },
      createSubscription: function (_, actions) {
        return actions.subscription.create({
          plan_id: process.env.PAYPAL_PLAN_ID,
          application_context: {
            shipping_preference: 'NO_SHIPPING'
          }
        })
      },
      onApprove: function (data) {
        fetch('/payments/paypal-create', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(data)
        })
          .then(response => {
            if (!response.ok) { throw new Error('Subscription failed') }
            return response.json()
          })
          .then(data => {
            Turbolinks.visit(data.location)
          })
      }
    })

    buttons.render('#paypal-button-container').catch((err) => {
      console.warn(
        "Warning - Caught an error when attempting to render", err
      )
    })
  })
})
