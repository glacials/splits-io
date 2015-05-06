class CreateSplits < ActiveRecord::Migration
  def change
    create_table :splits do |t|
      t.belongs_to :run, index: true, foreign_key: true
      t.integer :position
      t.string :name
      t.float :real_duration
      t.float :best_real_duration
      t.float :game_duration
      t.float :best_game_duration
    end
  end
end
