class Api::Webhooks::PaypalController < ApplicationController

  # "Auto Return URL" endpoint definited within paypals configuration.
  # Account Settings > Website Payments > Website Preferences.
  def create
    Paypal::Subscribe.create(params, current_user)

    render json: { location: subscription_path }, status: :ok
  end

  # Endpoint used within the internal "unsubscribe" functionality.
  def paypal_unsub
    Paypal::Subscribe.cancel_all(current_user)

    redirect_to subscriptions_path
  end
end
