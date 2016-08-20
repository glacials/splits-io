class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, index: true
      t.string :stripe_subscription_id
      t.string :stripe_plan_id
      t.string :stripe_customer_id
    end
  end
end
