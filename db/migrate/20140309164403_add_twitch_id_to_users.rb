class AddTwitchIdToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :twitch_id, :integer
  end
end
