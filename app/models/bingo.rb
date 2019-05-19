class Bingo < ApplicationRecord
  include Raceable

  belongs_to :game

  def self.type
    :bingo
  end

  def to_s
    "#{game} Bingo"
  end
end
