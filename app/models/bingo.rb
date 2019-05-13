class Bingo < ApplicationRecord
  include Raceable

  belongs_to :game

  def self.type
    :bingo
  end

  def to_s
    "#{game} Bingo"
  end

  def url_params
    [type, id]
  end
end
