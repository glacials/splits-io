module Raceable
  extend ActiveSupport::Concern

  included do
    # These can only be accessed from classes that include this module, not from the module itself
    enum visibility: {public: 0, invite_only: 1, secret: 2}, _suffix: true

    belongs_to :owner, foreign_key: :user_id, class_name: 'User'
    has_many :entrants, as: :raceable, dependent: :destroy
    has_many :users, through: :entrants
    has_one :chat_room, dependent: :destroy, as: :raceable
    has_many :chat_messages, through: :chat_room

    has_secure_token :join_token

    validates :status_text, presence: true

    after_create { |record| ChatRoom.create!(raceable: record) }

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

    def type
      self.class.string_type
    end

    def bingo?
      type == 'bingo'
    end

    def randomizer?
      type == 'randomizer'
    end

    def race?
      type == 'race'
    end
  end

  OPEN_ENTRY = 'Open Entry'.freeze
  IN_PROGRESS = 'In Progress'.freeze
  ENDED = 'Ended'.freeze
  RACE_TYPES = [StandardRace, BingoRace, RandomizerRace].freeze

  def self.race_from_type(type)
    RACE_TYPES.each { |klass| return klass if klass.string_type == type }

    nil
  end
end
