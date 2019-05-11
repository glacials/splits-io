class RandomizerRace < ApplicationRecord
  include Raceable

  belongs_to :game

  validates :seed, presence: true

  def self.string_type
    'randomizer'
  end

  def to_s
    "#{game} - Randomizer"
  end

  def url_params
    [type, id]
  end
end
