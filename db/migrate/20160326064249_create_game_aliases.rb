class CreateGameAliases < ActiveRecord::Migration
  def change
    enable_extension :citext

    create_table :game_aliases do |t|
      t.belongs_to :game, index: true, foreign_key: true
      t.citext :name
    end
    add_index :game_aliases, :name, unique: true

    Game.find_each do |game|
      game.aliases.create(name: game.name)
    end
  end
end
