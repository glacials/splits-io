class Randomizer < ApplicationRecord
  include Raceable

  belongs_to :game
  has_many_attached :files

  def self.type
    :randomizer
  end

  def to_s
    "#{game} Randomizer"
  end
end
