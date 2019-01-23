class MigrateSrlGames < ActiveRecord::Migration[5.2]
  def up
    Game.where.not(shortname: nil).left_outer_joins(:srl).where(speed_runs_live_games: {id: nil}).find_each do |game|
      SpeedRunsLiveGame.create(
        game:            game,
        name:            game.name,
        shortname:       game.shortname
      )
    end
  end

  def down
    Game.where(shortname: nil).find_each do |game|
      game.update(shortname: game.srl.shortname)
    end
  end
end
