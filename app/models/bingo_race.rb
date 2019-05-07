class BingoRace < ApplicationRecord
  include Raceable

  belongs_to :game

  def to_s
    "#{game} - Bingo"
  end

  def url_params
    [:bingo, id]
  end
end
