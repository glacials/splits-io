require 'speedrundotcom'

class SpeedrunDotComCategory < ApplicationRecord
  belongs_to :category

  def self.from_category!(category)
    return category.srdc if category.srdc.present?

    if category.game.srdc.nil?
      srdc_game = SpeedrunDotComGame.from_game!(category.game)
      return if srdc_game.nil? || !srdc_game.persisted?
    end

    result = SpeedrunDotCom::Category.from_game(category.game.srdc.srdc_id).find do |result|
      result['name'].downcase == category.name.downcase
    end
    return if result.nil?

    new(srdc_id: result['id'], category: category).from_result!(result)
  end

  def sync!
    from_result!(SpeedrunDotCom::Category.from_id(srdc_id))
  end

  def from_result!(result)
    update(
      name:        result['name'],
      url:         result['weblink'],
      misc:        result['miscellaneous'],
      rules:       result['rules'],
      min_players: result['players']['type'] == 'up-to' ? 1 : result['players']['value'],
      max_players: result['players']['value']
    ) && self
  end
end
