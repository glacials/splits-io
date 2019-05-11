class ChatRoom < ApplicationRecord
  belongs_to :raceable, polymorphic: true
  has_many :chat_messages, dependent: :destroy
end
