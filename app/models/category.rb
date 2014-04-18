class Category < ActiveRecord::Base
  belongs_to :game
  has_many :runs
end
