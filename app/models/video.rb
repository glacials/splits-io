class Video < ApplicationRecord
  belongs_to :videoable, polymorphic: true

  validates_with VideoValidator
end
