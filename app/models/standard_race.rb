class StandardRace < ApplicationRecord
  include Raceable

  belongs_to :user
  belongs_to :category
  has_one :game, through: :category

  def self.string_type
    'race'
  end

  def to_s
    "#{game} - #{category}"
  end

  def url_params
    [type, id]
  end
end
