class RandomizerRace < ApplicationRecord
  include Raceable

  belongs_to :game

  def to_s
    "#{game} - Randomizer"
  end

  def url_params
    [:randomizer, id]
  end
end
