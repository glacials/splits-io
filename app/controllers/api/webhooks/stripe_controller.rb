class Api::Webhooks::StripeController < ApplicationController
  before_action :set_event, only: %i[create]
  before_action :set_subscriptions, only: %i[create]

  def create
    case @event.type
    when 'checkout.session.completed'
      @subscriptions.cancel_all!
      Subscription.create(
        user_id: @event.data.object.client_reference_id,
        stripe_session_id: @event.data.object.id,
        stripe_plan_id: @event.data.object.display_items[0].plan.id,
        stripe_subscription_id: @event.data.object.subscription,
        stripe_payment_intent_id: @event.data.object.payment_intent,
        stripe_customer_id: @event.data.object.customer,
      )
    when 'customer.subscription.deleted'
      @subscriptions.update_all(ended_at: Time.now.utc)
    end
  end

  private

  def set_event
    @event = Stripe::Webhook.construct_event(
      request.body.read,
      request.headers['HTTP_STRIPE_SIGNATURE'],
      ENV['STRIPE_WEBHOOK_SECRET'],
    )
  end

  def set_subscriptions
    @subscriptions = Subscription.where(user_id: @event.data.object.client_reference_id)
  end
end
