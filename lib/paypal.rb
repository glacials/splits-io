# With the existing configuration of payments on the backend,
# it was much lower of a lift to use the existing database columns
# that are prefixed with stripe. There are still ways to differentiate
# subscription platforms based on the unique stripe_plan_id. With more
# time I would restructure the database, removing the stripe_ prefix
# and then adding an external_merchant:string column to easily tell
# the difference in subscriptions.

class Paypal
  def self.client
    RestClient::Resource.new(ENV["PAYPAL_API_HOST"])
  end

  # check_subscription(subscription_id: String)
  # Calls PayPal API to find a subscription ID to ensure it is valid.
  def self.check_subscription(data)
    HTTParty.get(
      URI::HTTPS.build(host: ENV["PAYPAL_API_HOST"], path: "/v1/billing/subscriptions/#{data["subscriptionID"]}"),
      basic_auth: AUTH,
      headers: { "Content-Type" => "application/json", "Accept" => "application/json" },
    )
  end

  # create(data: Hash, user: User)
  # Finds all paypal subscriptions and cancels them.
  # Creates a subscription for the user based on data returned from paypal.
  def self.create(data, user)
    response = check_subscription(data)

    if response.ok?
      begin
        cancel_all(user)
        subscription = user.subscriptions.create!(
          stripe_plan_id: ENV["PAYPAL_PLAN_ID"],
          stripe_subscription_id: data["subscriptionID"],
          stripe_session_id: data["orderID"],
          stripe_payment_intent_id: data["billingToken"],
        )

        subscription
      rescue => e
        {
          error: e.inspect,
          response: response.inspect,
          message: "Failed to create user subscription for #{user&.id}",
        }
      end
    else
      {
        error: "Failed to find valid subscription",
        response: response.inspect,
      }
    end
  end

  # Cancel a specific subscription by ID. The ID given should be the
  # PayPal-side subscription ID, not the Splits.io-side subscription ID.
  def self.cancel(provider_subscription_id)
    response = client["/v1/billing/subscriptions/#{provider_subscription_id}/cancel"].execute(
      method: :post,
      headers: { "Accept": "application/json" },
      user: ENV["PAYPAL_CLIENT_ID"],
      pass: ENV["PAYPAL_CLIENT_SECRET"],
    )

    JSON.parse(response.body)
  end
end
