class AddSrlIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :integer
  end
end
