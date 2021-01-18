class Api::Webhooks::PaypalController < ApplicationController
  before_action :verify

  # Triggered when a user unsubscribes on paypal
  def create
    case request["event_type"]
    when "BILLING.SUBSCRIPTION.CANCELLED"
      subscription = Subscription.find_by(
        stripe_plan_id: request["resource"]["plan_id"],
        stripe_subscription_id: request["resource"]["id"],
      )
      subscription&.update(canceled_at: Time.now.utc)
    when "BILLING.SUBSCRIPTION.ACTIVATED"
      subscription = Subscription.find_by(
        stripe_plan_id: request["resource"]["plan_id"],
        stripe_subscription_id: request["resource"]["id"],
      )
      subscription&.update(canceled_at: Time.now.utc)
    end
  end

  private

  def verify
    transmission_id = request.headers["PayPal-Transmission-ID"]
    timestamp = request.headers["PayPal-Transmission-Time"]
  end
end
