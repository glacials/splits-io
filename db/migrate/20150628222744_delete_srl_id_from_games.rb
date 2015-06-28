class DeleteSrlIdFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :srl_id
  end
end
