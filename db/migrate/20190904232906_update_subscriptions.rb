class UpdateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    # Old subscriptions table is from 2016 and does not use UUIDs
    drop_table :subscriptions do |t|
      t.belongs_to :user, index: true
      t.string :stripe_subscription_id
      t.string :stripe_plan_id
      t.string :stripe_customer_id
    end

    create_table :subscriptions, id: :uuid do |t|
      t.belongs_to :user, index: true
      t.string :stripe_session_id
      t.string :stripe_plan_id
      t.string :stripe_subscription_id
      t.string :stripe_payment_intent_id
      t.string :stripe_customer_id

      t.datetime :canceled_at

      t.timestamps
    end
  end
end
