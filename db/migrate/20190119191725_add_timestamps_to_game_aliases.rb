class AddTimestampsToGameAliases < ActiveRecord::Migration[5.2]
  def change
    add_timestamps(:game_aliases, null: false, default: Time.now.utc)
    change_column_default(:game_aliases, :created_at, from: Time.now.utc, to: nil)
    change_column_default(:game_aliases, :updated_at, from: Time.now.utc, to: nil)
  end
end
