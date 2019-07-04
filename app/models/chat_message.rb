class ChatMessage < ApplicationRecord
  belongs_to :race
  belongs_to :user

  validates :body, presence: true
  validate do
    errors.add(:base, 'Race locked') if race.locked?
  end
end
