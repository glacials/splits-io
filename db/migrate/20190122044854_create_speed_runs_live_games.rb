class CreateSpeedRunsLiveGames < ActiveRecord::Migration[5.2]
  def up
    create_table :speed_runs_live_games, id: :uuid do |t|
      t.belongs_to :game, foreign_key: true, index: {unique: true}

      t.string  :srl_id,          null: false, index: {unique: true}
      t.string  :name,            null: false
      t.string  :shortname,       null: false, index: {unique: true}
      t.float   :popularity,      null: true
      t.integer :popularity_rank, null: true

      t.timestamps
    end

    Game.find_each do |game|
      srl = SpeedRunsLive::Game.from_shortname(game.shortname)
      next if srl['id'].nil?

      SpeedRunsLiveGame.create(
        game:            game,
        name:            game.name,
        shortname:       game.shortname,
        srl_id:          srl['id'],
        popularity:      srl['popularity'],
        popularity_rank: srl['popularityrank']
      )
    end

    remove_column :games, :shortname
  end

  def down
    add_column :games, :shortname, :string, null: true, index: {unique: true}

    SpeedRunsLiveGame.find_each do |srl|
      srl.game.update(shortname: srl.shortname)
    end

    drop_table :speedruns_live_games
  end
end
