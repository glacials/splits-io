class Api::Webhooks::Paypal::BillingSubscriptionCancellationsController < Api::Webhooks::Paypal::ApplicationController
  def create
    subscription = PaypalSubscription.find_by(
      provider_plan_id: params[:resource][:plan_id],
      provider_subscription_id: params[:resource][:id],
    )
    subscription&.update(canceled_at: Time.now.utc)
  end

  private

  #
  # Returns the PayPal-side type string for a billing subscription
  # cancellation.
  #
  def event_type
    "BILLING.SUBSCRIPTION.CANCELLED"
  end
end
