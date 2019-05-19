class Race < ApplicationRecord
  include Raceable

  belongs_to :user
  belongs_to :category
  has_one :game, through: :category

  def self.type
    :race
  end

  def to_s
    "#{game} #{category}"
  end
end
