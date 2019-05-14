class ChatMessage < ApplicationRecord
  belongs_to :raceable, polymorphic: true
  belongs_to :user

  validates :body, presence: true
end
