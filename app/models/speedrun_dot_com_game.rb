require 'speedrundotcom'

class SpeedrunDotComGame < ApplicationRecord
  belongs_to :game

  def self.from_game!(game)
    return game.srdc if game.srdc.present?

    result = SpeedrunDotCom::Game.search(game.name).first
    return if result.nil?

    # If making a SpeedrunDotComGame from the above result would yield a duplicate, merge the given game into the
    # existing one. We do this inside here and not during Run/Game creation because we don't want to block Run/Game
    # creation (which itself blocks pageload) on Speedrun.com's API.
    existing_srdc_game = find_by(srdc_id: result['id']).present?
    if existing_srdc_game.present?
      game.merge_into!(existing_srdc_game.game)
      return existing_srdc_game
    end

    new(srdc_id: result['id'], game: game).from_result!(result)
  end

  def sync!
    from_result!(SpeedrunDotCom::Game.from_id(srdc_id))
  end

  def from_result!(result)
    update(
      name:           result['names']['international'],
      twitch_name:    result['names']['twitch'],
      shortname:      result['abbreviation'],
      url:            result['weblink'],
      favicon_url:    result['assets']['icon']['uri'],
      cover_url:      result['assets']['cover-large']['uri'],
      default_timing: result['ruleset']['default-time'] == 'ingame' ? 'game' : 'real',
      show_ms:        result['ruleset']['show-milliseconds']
    ) && self
  end
end
