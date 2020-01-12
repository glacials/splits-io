class SpeedrunDotComCategory < ApplicationRecord
  belongs_to :category

  has_many :variables, class_name: 'SpeedrunDotComGameVariable', dependent: :destroy
end
