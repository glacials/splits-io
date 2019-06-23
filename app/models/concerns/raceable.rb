module Raceable
  extend ActiveSupport::Concern

  included do
    # These can only be accessed from classes that include this module, not from the module itself
    enum visibility: {public: 0, invite_only: 1, secret: 2}, _suffix: true

    belongs_to :owner, foreign_key: :user_id, class_name: 'User'
    has_many :entries, as: :raceable, dependent: :destroy
    has_many :users, through: :entries
    has_many :chat_messages, as: :raceable, dependent: :destroy

    has_secure_token :join_token

    scope :started,    -> { where.not(started_at: nil) }
    scope :unstarted,  -> { where(started_at: nil) }
    scope :ongoing,    -> { started.unfinished }

    after_create { entries.create(user: owner) }

    def self.unfinished
      # Distinct call will not return raceables with no entries, so union all raceables with 0 entries
      joins(:entries).where(entries: {finished_at: nil, forfeited_at: nil}).distinct.union(
        left_outer_joins(:entries).where(entries: {id: nil})
      )
    end

    def self.finished
      joins(:entries).where.not(entries: {finished_at: nil}).or(joins(:entries).where.not(entries: {forfeited_at: nil})).group(:id)
    end

    # unabandoned returns races that have had activity (e.g. creation, new entry, etc.) in the last hour
    # or have more than 2 entries. this includes races that have finished (excluding secret races)
    def self.unabandoned
      case name # self.name refers to the class including this concern
      when 'Race'
        where('races.updated_at > ?', 1.hour.ago)
      when 'Randomizer'
        where('randomizers.updated_at > ?', 1.hour.ago)
      when 'Bingo'
        where('bingos.updated_at > ?', 1.hour.ago)
      end.not_secret_visibility.or(
        where(id: Entry.having('count(*) > 1').group(:raceable_id).select(:raceable_id)).not_secret_visibility
      )
    end

    # active returns all non-finished unabandonded races (excluding secret races)
    def self.active
      unabandoned.unfinished.not_secret_visibility
    end

    def started?
      started_at.present?
    end

    def in_progress?
      started? && !finished?
    end

    def finished?
      started? && entries.where(finished_at: nil, forfeited_at: nil).none?
    end

    def finished_at
      [
        entries.where.not(finished_at: nil).maximum(:finished_at),
        entries.where.not(forfeited_at: nil).maximum(:forfeited_at)
      ].compact.max
    end

    # Raceables are "locked" 30 minutes after they end to stop new messages coming in
    def locked?
      finished? && Time.now.utc > finished_at + 30.minutes
    end

    # potentially starts the raceable if all entrants are now ready
    def maybe_start!
      return if started? || entries.where(readied_at: nil).any? || entries.count < 2

      update(started_at: Time.now.utc + 20.seconds)
      Api::V4::RaceableBroadcastJob.perform_later(self, 'raceable_start_scheduled', "The #{type} is starting soon")
      Api::V4::GlobalRaceableUpdateJob.perform_later(self, 'raceable_start_scheduled', 'A race is starting soon')
    end

    # potentially send race end broadcast if all entrants are finished
    # note: this can potentially send multiple ending messages if called on an already finished raceable
    def maybe_end!
      return if !started? || entrants.where(finished_at: nil, forfeited_at: nil).any?

      Api::V4::RaceableBroadcastJob.perform_later(self, 'raceable_ended', "The #{type} has ended")
      Api::V4::GlobalRaceableUpdateJob.perform_later(self, 'raceable_ended', 'A race has ended')
    end

    def entry_for_user(user)
      return nil if user.nil?

      entries.find_by(user_id: user.id)
    end

    # checks if a given user should be able to act on a given raceable, returning true if any of the following pass
    # the user is an entrant in the race or is the race creator
    # the race status is not public and the provided token is correct
    # the race is public and the user is not in another race
    def joinable?(user: nil, token: nil)
      result = false
      result = true if entry_for_user(user).present? || belongs_to?(user)
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
