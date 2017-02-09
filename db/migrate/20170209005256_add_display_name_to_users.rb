class AddDisplayNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :twitch_display_name, :string
  end
end
