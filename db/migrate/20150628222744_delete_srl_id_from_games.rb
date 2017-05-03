class DeleteSrlIdFromGames < ActiveRecord::Migration[4.2]
  def change
    remove_column :games, :srl_id
  end
end
