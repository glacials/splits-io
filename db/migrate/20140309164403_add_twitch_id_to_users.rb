class AddTwitchIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitch_id, :integer
  end
end
