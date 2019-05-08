module Raceable
  extend ActiveSupport::Concern

  included do
    # These can only be accessed from classes that it is included in, not from the Raceable class
    enum visibility: {public: 0, invite_only: 1, secret: 2}, _suffix: true

    OPEN_ENTRY = 'Open Entry'.freeze
    IN_PROGRESS = 'In Progress'.freeze
    ENDED = 'Ended'.freeze

    belongs_to :owner, foreign_key: :user_id, class_name: 'User'
    has_many :entrants, as: :raceable, dependent: :destroy
    has_many :users, through: :entrants
    has_one :chat_room, dependent: :destroy
    has_many :chat_messages, through: :chat_room

    has_secure_token :auth_token

    validates :status_text, presence: true

    def started?
      started_at.present?
    end

    def in_progress?
      started? && !finished?
    end

    def finished?
      entrants.all? { |entrant| entrant.finished? || entrant.forfeited? }
    end

    def entrant_for_user(user)
      entrants.find_by(user_id: user.id)
    end
  end

  RACE_TYPES = [StandardRace, BingoRace, RandomizerRace].freeze

  def self.race_from_type(type)
    RACE_TYPES.each { |klass| return klass if klass.string_type == type }

    nil
  end
end
