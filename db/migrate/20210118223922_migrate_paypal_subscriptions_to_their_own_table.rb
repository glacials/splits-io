class MigratePaypalSubscriptionsToTheirOwnTable < ActiveRecord::Migration[6.0]
  def change
    create_table :paypal_subscriptions, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, null: false, index: { unique: true }

      t.string :provider_subscription_id, null: false, index: { unique: true }
      t.string :provider_status, null: false
      t.string :provider_plan_id, null: false

      t.timestamps
    end

    Subscription.where(stripe_plan_id: ENV["PAYPAL_PLAN_ID"]).find_each do |subscription|
      PayPalSubscription.create(
        user: subscription.user,
        provider_subscription_id: subscription.stripe_subscription_id,
        provider_plan_id: subscription.stripe_plan_id,
      ) && subscription.destroy
    end
  end
end
