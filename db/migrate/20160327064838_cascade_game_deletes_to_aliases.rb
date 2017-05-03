class CascadeGameDeletesToAliases < ActiveRecord::Migration[4.2]
  def change
    remove_foreign_key :game_aliases, :games
    add_foreign_key :game_aliases, :games, on_delete: :cascade
  end
end
