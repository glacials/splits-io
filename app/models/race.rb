class Race < ApplicationRecord
  validates_with RaceValidator

  ABANDON_TIME = 1.hour.freeze

  belongs_to :user

  belongs_to :game,     optional: true
  belongs_to :category, optional: true

  enum visibility: {public: 0, invite_only: 1, secret: 2}, _suffix: true

  belongs_to :owner, foreign_key: :user_id, class_name: 'User'
  has_many :entries, dependent: :destroy
  has_many :runners, through: :entries
  has_many :chat_messages, dependent: :destroy

  has_many_attached :attachments

  has_secure_token :join_token

  scope :started,    -> { where.not(started_at: nil) }
  scope :unstarted,  -> { where(started_at: nil) }
  scope :ongoing,    -> { started.unfinished }

  after_create { entries.create(runner: owner, creator: owner) }

  def self.unfinished
    # Distinct call will not return races with no entries, so union all races with 0 entries
    joins(:entries).where(entries: {finished_at: nil, forfeited_at: nil}).distinct.union(
      left_outer_joins(:entries).where(entries: {id: nil})
    )
  end

  def self.finished
    where.not(id: unfinished)
  end

  # unabandoned returns races that have had activity (e.g. creation, new entry, etc.) in the last hour
  # or have more than 2 entries. this includes races that have finished
  def self.unabandoned
    where('races.updated_at > ?', ABANDON_TIME.ago).or(
      where(id: Entry.nonghosts.having('count(*) > 1').group(:race_id).select(:race_id))
    )
  end

  # active returns all non-finished unabandoned races
  def self.active
    unabandoned.unfinished
  end

  def self.friendly_find!(slug)
    raise ActiveRecord::RecordNotFound if slug.nil?

    race = where('LEFT(races.id::text, ?) = ?', slug.length, slug).order(created_at: :asc).first
    raise ActiveRecord::RecordNotFound if race.nil?

    race
  end

  # with_ends modifies the returned Races to have an ended_at field, which represents the timestamp at which the last
  # entry finished or forfeited, or null if at least one entry has neither finished nor forfeited.
  def self.with_ends
    select('races.*,
      case
        when bool_or(entries.finished_at is null and entries.forfeited_at is null) then null
        else greatest(max(entries.finished_at), max(entries.forfeited_at))
      end as ended_at
    '.squish).left_outer_joins(:entries).group(:id)
  end

  def to_s
    "#{game} #{category} #{title}".presence || 'Untitled race'
  end

  def abandoned?
    updated_at < ABANDON_TIME.ago && entries.count < 2
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

  # Races are "locked" 30 minutes after they end to stop new messages coming in
  def locked?
    finished? && Time.now.utc > finished_at + 30.minutes
  end

  # potentially starts the race if all entries are now ready
  def maybe_start!
    return if started? || entries.where(readied_at: nil).any? || entries.count < 2

    update(started_at: Time.now.utc + 20.seconds)

    # Schedule ghost splits and finishes
    entries.ghosts.find_each do |entry|
      entry.update(finished_at: started_at + (entry.run.duration(Run::REAL).to_sec))
      Api::V4::RaceBroadcastJob.set(wait_until: started_at + entry.run.duration(Run::REAL).to_sec).perform_later(
        self, 'race_entries_updated', 'A ghost has finished'
      )
      entry.run.segments.with_ends.each do |segment|
        Api::V4::RaceBroadcastJob.set(wait_until: started_at + segment.end(Run::REAL).to_sec).perform_later(
          self, 'race_entries_updated', 'A ghost has split'
        )
      end
    end

    # Schedule cleanup job for a started race that was abandoned
     RaceCleanupJob.set(wait_until: started_at + 48.hours).perform_later(self)

    Api::V4::RaceBroadcastJob.perform_later(self, 'race_start_scheduled', 'The race is starting soon')
    Api::V4::GlobalRaceUpdateJob.perform_later(self, 'race_start_scheduled', 'A race is starting soon')
  end

  # potentially send race end broadcast if all entries are finished
  # note: this can potentially send multiple ending messages if called on an already finished race
  def maybe_end!
    return if !started? || entries.where(finished_at: nil, forfeited_at: nil).any?

    Api::V4::RaceBroadcastJob.perform_later(self, 'race_ended', 'The race has ended')
    Api::V4::GlobalRaceUpdateJob.perform_later(self, 'race_ended', 'A race has ended')
  end

  # checks if a given user should be able to act on a given race, returning true if any of the following pass
  # the user is an entrant in the race or is the race creator, or
  # the race visibility is not public and the provided token is correct, or
  # the race is public
  def joinable?(user: nil, token: nil)
    result = false
    result = true if entries.find_for(user).present? || belongs_to?(user)
    result = true if (invite_only_visibility? || secret_visibility?) && token == join_token
    result = true if public_visibility?

    result
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

  def title
    notes.try(:lines).try(:first)
  end

  def duration
    return Duration.new((finished_at - started_at) * 1000) if finished_at.present?
    return Duration.new((Time.now.utc - started_at) * 1000) if in_progress?

    Duration.new(nil)
  end
end
