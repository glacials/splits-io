class Game < ActiveRecord::Base
  has_many :categories
  delegate :runs, to: :categories
end
