import { loadScript } from '@paypal/paypal-js';

document.addEventListener("turbolinks:load", function() {
  loadScript({
    'client-id': process.env.PAYPAL_CLIENT_ID,
    'vault': 'true',
    'intent': 'subscription'
  }).then(() => {
    const buttons = paypal.Buttons({
      style: {
          shape: 'rect',
          color: 'gold',
          layout: 'horizontal',
          label: 'subscribe'
      },
      createSubscription: function(data, actions) {
        return actions.subscription.create({
          plan_id: process.env.PAYPAL_PLAN_ID,
          application_context: {
            shipping_preference: 'NO_SHIPPING'
          }
        });
      },
      onApprove: function(data) {
        $.ajax({
          url : "/api/webhooks/paypal",
          method : "POST",
          data : data,
          dataType : "json",
          success: function(response){
            window.location = response.location;
          }
        });
      }
    });

    buttons.render('#paypal-button-container').catch((err) => {
      console.warn(
        "Warning - Caught an error when attempting to render", err
      );
    });
  });
});
