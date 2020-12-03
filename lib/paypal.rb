# With the existing configuration of payments on the backend,
# it was much lower of a lift to use the existing database columns
# that are prefixed with stripe. There are still ways to differentiate
# subscription platforms based on the unique stripe_plan_id. With more
# time I would restructure the database, removing the stripe_ prefix
# and then adding an external_merchant:string column to easily tell
# the difference in subscriptions.

class Paypal
  class Subscribe
    if Rails.env.production?
      UNSUB_BASE_URL = "https://api-m.paypal.com/v1/billing/subscriptions"
    else
      UNSUB_BASE_URL = "https://api-m.sandbox.paypal.com/v1/billing/subscriptions"
    end
    AUTH = { username: ENV["PAYPAL_CLIENT_ID"], password: ENV["PAYPAL_SECRET_KEY"] }

    # validate_subscription(subscription_id: String)
    # Calls PayPal API to ensure the subscription ID is valid.
    # Returns true or false
    def self.validate_subscription(subscription_id)
      return false unless subscription_id.present?
      response = HTTParty.get(URI.parse("#{UNSUB_BASE_URL}/#{subscription_id}"),
        basic_auth: AUTH,
        headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      )
      response.ok?
    end

    # create(data: Hash, user: User)
    # Finds all paypal subscriptions and cancels them.
    # Creates a subscription for the user based on data returned from paypal.
    def self.create(data, user)
      return false unless validate_subscription(data["subscriptionID"])
      cancel_all(user)

      user.subscriptions.create!(
        stripe_plan_id: ENV["PAYPAL_PLAN_ID"],
        stripe_subscription_id: data["subscriptionID"],
        stripe_session_id: data["orderID"],
        stripe_payment_intent_id: data["billingToken"]
      )
    end

    # cancel_all(user: User)
    # Identifies paypal subscriptions based on the plan id. For each subscription,
    # send out an external call to the /cancel endpoint in paypal to cancel the external
    # subscription. The subscription record internally is then updated setting the
    # canceled_at field (if applicable)
    def self.cancel_all(user)
      subscriptions = user.subscriptions.where(stripe_plan_id: ENV["PAYPAL_PLAN_ID"])
      return unless subscriptions.present?

      subscriptions.each do |sub|
        if sub.stripe_subscription_id.present?
          response = HTTParty.post(URI.parse("#{UNSUB_BASE_URL}/#{sub.stripe_subscription_id}/cancel"),
            basic_auth: AUTH,
            headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
          )
        end
        sub.update(canceled_at: Time.now.utc) if sub.canceled_at.nil?
      end
    end
  end
end
