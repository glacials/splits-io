class StandardRace < ApplicationRecord
  include Raceable

  belongs_to :category
  has_one :game, through: :category

  def to_s
    "#{game} - #{category}"
  end

  def url_params
    [:standard, id]
  end
end
