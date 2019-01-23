require 'speedrunslive'

class SpeedRunsLiveGame < ApplicationRecord
  belongs_to :game

  def self.from_game!(game)
    return game.srl if game.srl.present?

    result = SpeedRunsLive::Game.from_name(game.name)
    new(srl_id: result['id'], game: game).from_result!(result)
  end

  def sync!
    from_result!(SpeedRunsLive::Game.from_shortname(shortname))
  end

  def from_result!(result)
    return if result.nil? || result['errorCode'].present?

    update(
      name:            result['name'],
      shortname:       result['abbrev'],
      popularity:      result['popularity'],
      popularity_rank: result['popularityrank']
    ) && self
  end

  def url
    return nil if shortname.blank?

    URI::HTTP.build(
      host: 'speedrunslive.com',
      path: '/races/game/',
      fragment: "!/#{shortname}"
    ).to_s
  end
end
