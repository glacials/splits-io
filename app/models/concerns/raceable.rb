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

    # current returns races that have had activity (e.g. creation, new entrant, etc.) in the last hour.
    def self.current
      case name # self.name refers to the class including this concern
      when 'Race'
        where('races.updated_at > ?', 1.hour.ago)
      when 'Randomizer'
        where('randomizers.updated_at > ?', 1.hour.ago)
      when 'Bingo'
        where('bingos.updated_at > ?', 1.hour.ago)
      end.or(where(id: Entrant.having('count(*) > 1').group(:raceable_id).select(:raceable_id)))
    end

    # started returns races that have started. Both finished and unfinished races are included.
    def self.started
      where.not(started_at: nil)
    end

    # unstarted returns races that have not started.
    #
    # Returned races are not necessarily current; a race may have been created a year ago but never started.
    def self.unstarted
      where(started_at: nil)
    end

    # unfinished returns races that have not finished. Both started and unstarted races are included.
    #
    # Returned races are not necessarily current; a race may have been created a year ago but never started, or started
    # a year ago but never finished.
    def self.unfinished
      joins(:entrants).where(entrants: {finished_at: nil, forfeited_at: nil}).distinct
    end

    # ongoing returns all races that have started but not finished.
    def self.ongoing
      started.unfinished
    end

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
      finished? && Time.now.utc > entrants.order(updated_at: :desc).pluck(:updated_at).first + 30.minutes
    end

    def entrant_for_user(user)
      return nil if user.nil?

      entrants.find_by(user_id: user.id)
    end

    def joinable?(user: nil, token: nil)
      result = false
      result = true if entrant_for_user(user).present? || owner == user
      result = true if (invite_only_visibility? || secret_visibility?) && token == join_token
      result = true if public_visibility? && !user.try(:in_race?)

      result
    end

    def type
      self.class.type
    end

    def bingo?
      type == Bingo.type
    end

    def randomizer?
      type == Randomizer.type
    end

    def race?
      type == Race.type
    end
  end

  RACE_TYPES = [Race, Bingo, Randomizer].freeze

  def self.race_from_type(type)
    RACE_TYPES.find { |klass| klass.type.to_s == type.to_s }
  end
end
