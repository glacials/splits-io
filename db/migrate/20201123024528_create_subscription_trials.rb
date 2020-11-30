class CreateSubscriptionTrials < ActiveRecord::Migration[6.0]
  def change
    create_table :subscription_trials, id: :uuid do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
