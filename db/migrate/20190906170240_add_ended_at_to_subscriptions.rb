class AddEndedAtToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :ended_at, :datetime, null: true
  end
end
