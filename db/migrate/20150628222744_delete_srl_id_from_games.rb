class DeleteSrlIdFromGames < ActiveRecord::Migration
  def change
    remove_column :games
  end
end
