class Payments::PaypalController < ApplicationController

  # Triggered from in paypal.js upon approval of paypal subscription creation
  def create
    subscription = Paypal::Subscribe.create(params, current_user)

    if subscription.present?
      render json: { location: subscription_path }, status: :ok
    else
      render json: { error: "Invalid subscription ID"}, status: :unprocessable_entity
    end
  end

  # Endpoint used within the internal "unsubscribe" functionality.
  def unsubscribe
    Paypal::Subscribe.cancel_all(current_user)

    redirect_to subscriptions_path
  end

end
