class Rivalry < ApplicationRecord
  validates :category, uniqueness: {scope: :from_user_id}

  belongs_to :category
  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user, class_name: 'User'

  has_one :game, through: :category

  scope :for_category, ->(category) { where(category: category) }
end
