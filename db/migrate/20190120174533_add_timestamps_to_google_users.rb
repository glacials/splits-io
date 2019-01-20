class AddTimestampsToGoogleUsers < ActiveRecord::Migration[5.2]
  def change
    add_timestamps(:google_users, null: false, default: Time.now.utc)
    change_column_default(:google_users, :created_at, from: Time.now.utc, to: nil)
    change_column_default(:google_users, :updated_at, from: Time.now.utc, to: nil)
  end
end
