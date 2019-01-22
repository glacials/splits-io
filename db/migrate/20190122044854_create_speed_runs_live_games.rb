class CreateSpeedRunsLiveGames < ActiveRecord::Migration[5.2]
  def change
    create_table :speed_runs_live_games, id: :uuid do |t|
      t.belongs_to :game, foreign_key: true, index: {unique: true}

      t.string  :srl_id,          null: true,  index: {unique: true}
      t.string  :name,            null: false
      t.string  :shortname,       null: false, index: {unique: true}
      t.float   :popularity,      null: true
      t.integer :popularity_rank, null: true

      t.timestamps
    end
  end
end
