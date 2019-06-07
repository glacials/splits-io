class ChatMessage < ApplicationRecord
  belongs_to :raceable, polymorphic: true
  belongs_to :user

  validates :body, presence: true
  validate do
    errors.add(:base, 'Raceable locked') if raceable.locked?
  end
end
