class Randomizer < ApplicationRecord
  include Raceable

  belongs_to :game

  def self.type
    :randomizer
  end

  def to_s
    "#{game} Randomizer"
  end
end
