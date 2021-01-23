class Api::Webhooks::Paypal::BillingSubscriptionActivationsController < Api::Webhooks::Paypal::ApplicationController
  def create
    subscription = Subscription.find_or_create_by(
      provider_plan_id: request["resource"]["plan_id"],
      provider_subscription_id: request["resource"]["id"],
    )
  end

  private

  #
  # Returns the PayPal-side type string for a billing subscription
  # activation.
  #
  def event_type
    "BILLING.SUBSCRIPTION.ACTIVATED"
  end
end
