module Raceable
  extend ActiveSupport::Concern

  included do
    # These can only be accessed from classes that include this module, not from the module itself
    enum visibility: {public: 0, invite_only: 1, secret: 2}, _suffix: true
    enum status: {open: 0, in_progress: 1, ended: 2}, _suffix: true

    belongs_to :owner, foreign_key: :user_id, class_name: 'User'
    has_many :entrants, as: :raceable, dependent: :destroy
    has_many :users, through: :entrants
    has_many :chat_messages, as: :raceable, dependent: :destroy

    has_secure_token :join_token

    def started?
      started_at.present?
    end

    def in_progress?
      started? && !finished?
    end

    def finished?
      started? && entrants.where(finished_at: nil, forfeited_at: nil).none?
    end

    def locked?
      finished? && Time.now.utc < entrants.order(updated_at: :desc).first.pluck(:updated_at) + 30.minutes
    end

    def entrant_for_user(user)
      entrants.find_by(user_id: user.id)
    end

    def type
      self.class.type
    end

    def bingo?
      type == :bingo
    end

    def randomizer?
      type == :randomizer
    end

    def race?
      type == :race
    end
  end

  RACE_TYPES = [Race, Bingo, Randomizer].freeze

  def self.race_from_type(type)
    RACE_TYPES.find { |klass| klass.type.to_s == type.to_s }
  end
end
