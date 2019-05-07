class ChatRoom < ApplicationRecord
  belongs_to :race
  has_many :chat_messages, dependent: :destroy
end
