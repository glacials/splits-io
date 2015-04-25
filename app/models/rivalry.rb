class Rivalry < ActiveRecord::Base
  validates_uniqueness_of :category, scope: :from_user_id

  belongs_to :category
  belongs_to :from_user, class_name: User, touch: true
  belongs_to :to_user, class_name: User

  has_one :game, through: :category

  scope :for_category, ->(category) { where(category: category) }
end
