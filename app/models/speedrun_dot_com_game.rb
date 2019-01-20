require 'speedrundotcom'

class SpeedrunDotComGame < ApplicationRecord
  belongs_to :game

  def self.from_game!(game)
    return game.srdc if game.srdc.present?

    result = SpeedrunDotCom::Game.search(game.name).first
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
