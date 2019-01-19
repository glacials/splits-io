class AddTimestampsToRivalries < ActiveRecord::Migration[5.2]
  def change
    add_timestamps(:rivalries, null: false, default: Time.now.utc)
    change_column_default(:rivalries, :created_at, from: Time.now.utc, to: nil)
    change_column_default(:rivalries, :updated_at, from: Time.now.utc, to: nil)
  end
end
