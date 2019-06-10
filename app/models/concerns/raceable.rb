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

    scope :started,    -> { where.not(started_at: nil) }
    scope :unstarted,  -> { where(started_at: nil) }
    scope :unfinished, -> { joins(:entrants).where(entrants: {finished_at: nil, forfeited_at: nil}).distinct }
    scope :ongoing,    -> { started.unfinished }

    after_create { entrants.create(user: owner) }

    # unabandoned returns races that have had activity (e.g. creation, new entrant, etc.) in the last hour
    # or have more than 2 entrants. this includes races that have finished (excluding secret races)
    def self.unabandoned
      # TODO: remove secret races from this
      case name # self.name refers to the class including this concern
      when 'Race'
        where('races.updated_at > ?', 1.hour.ago).not_secret_visibility
      when 'Randomizer'
        where('randomizers.updated_at > ?', 1.hour.ago).not_secret_visibility
      when 'Bingo'
        where('bingos.updated_at > ?', 1.hour.ago).not_secret_visibility
      end.or(where(id: Entrant.having('count(*) > 1').group(:raceable_id).select(:raceable_id)).not_secret_visibility)
    end

    # active returns all non-finished unabandonded races (excluding secret races)
    def self.active
      unabandoned.unfinished.not_secret_visibility
    end

    def self.active
      unabandoned.unfinished
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

    def finished_at
      [
        entrants.order(finished_at: :desc).first.finished_at,
        entrants.order(forfeited_at: :desc).first.forfeited_at
      ].compact.max
    end

    # Races are "locked" 30 minutes after they end to stop new messages coming in
    def locked?
      finished? && Time.now.utc > entrants.order(updated_at: :desc).pluck(:updated_at).first + 30.minutes
    end

    def maybe_start!
      return false if started? || !entrants.all?(&:ready?) || entrants.count < 2

      update(started_at: Time.now.utc + 20.seconds, status: :in_progress)
      Api::V4::RaceBroadcastJob.perform_later(self, 'race_start_scheduled', "The #{type} is starting soon")
      Api::V4::GlobalRaceUpdateJob.perform_later(self, 'race_start_scheduled', 'A race is starting soon')
    end

    def maybe_end!
      return false if !started? || !entrants.all?(&:done?)

      update(status: :ended)
      Api::V4::RaceBroadcastJob.perform_later(self, 'race_ended', "The #{type} has ended")
      Api::V4::GlobalRaceUpdateJob.perform_later(self, 'race_ended', 'A race has ended')
      true
    end

    def entrant_for_user(user)
      return nil if user.nil?

      entrants.find_by(user_id: user.id)
    end

    def joinable?(user: nil, token: nil)
      result = false
      result = true if entrant_for_user(user).present? || belongs_to?(user)
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

    # belongs_to? returns true if the given user owns this race, or false otherwise. Use this method instead of direct
    # comparison to prevent nil users from editing races without owners (e.g. logged-out users & races whose owners
    # deleted their accounts).
    def belongs_to?(user)
      return nil if user.nil?

      owner == user
    end

    def to_param
      (0..id.length).each do |length|
        return id[0..length] if self.class.where('LEFT(id::text, ?) = ?', length + 1, id[0..length]).count == 1
      end
    end
  end

  RACE_TYPES = [Race, Bingo, Randomizer].freeze

  def self.race_from_type(type)
    RACE_TYPES.find { |klass| klass.type.to_s == type.to_s }
  end
end
