class Api::Webhooks::PaypalController < ApplicationController
  # Triggered when a user unsubscribes on paypal
  def create
    if request["event_type"] == "BILLING.SUBSCRIPTION.CANCELLED"
      subscription = Subscription.where(
        stripe_plan_id: request["resource"]["plan_id"],
        stripe_subscription_id: request["resource"]["id"]
      ).first
      subscription&.update(canceled_at: Time.now.utc)
    end
  end
end
