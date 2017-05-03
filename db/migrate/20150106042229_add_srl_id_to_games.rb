class AddSrlIdToGames < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :srl_id, :integer
  end
end
