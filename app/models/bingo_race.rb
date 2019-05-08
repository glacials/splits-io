class BingoRace < ApplicationRecord
  include Raceable

  belongs_to :game

  validates :card, presence: true

  def self.string_type
    'bingo'
  end

  def to_s
    "#{game} - Bingo"
  end

  def url_params
    [:bingo, id]
  end
end
