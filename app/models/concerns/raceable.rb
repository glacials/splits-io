module Raceable
  extend ActiveSupport::Concern

  included do
    OPEN = 'Open Entry'.freeze
    IN_PROGRESS = 'In Progress'.freeze
    ENDED = 'Ended'.freeze

    belongs_to :owner, foreign_key: :user_id, class_name: 'User'
    has_many :entrants, as: :raceable, dependent: :destroy
    has_many :users, through: :entrants
    has_one :chat_room, dependent: :destroy
    has_many :chat_messages, through: :chat_room

    has_secure_token :auth_token

    def public?
      listed? && !invite?
    end

    def invite_only?
      listed? && invite?
    end

    def secret?
      !listed?
    end

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

    def visibility!(type)
      # When given an invalid type, the column defaults will make the race public
      case type
      when 'public'
        self.listed = true
        self.invite = false
      when 'invite_only'
        self.listed = true
        self.invite = true
      when 'secret'
        self.listed = false
        self.invite = true
      end
    end
  end

  def self.race_from_type(type)
    case type
    when 'standard'
      StandardRace
    when 'bingo'
      BingoRace
    when 'randomizer'
      RandomizerRace
    end
  end
end
