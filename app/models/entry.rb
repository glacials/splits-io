class Entry < ApplicationRecord
  belongs_to :race, touch: true
  belongs_to :runner, class_name: 'User', optional: true
  belongs_to :creator, class_name: 'User'
  belongs_to :run, dependent: :destroy, optional: true

  # coentries can be called instead of entry.race.entries to avoid needing to join on races. It can also be used as a
  # join model to e.g. discover number of 1st/2nd/3rd places by user more cheaply as a Rails-friendly query. This
  # relation INCLUDES "myself", e.g. entry.coentries will include entry in returned values.
  has_many :coentries, source: :entries, class_name: 'Entry', primary_key: 'race_id', foreign_key: 'race_id'

  validates_with EntryValidator
  # Validators are not called before destroy's, so manually hook and prevent if race is started
  before_destroy :validate_destroy

  scope :ready,    -> { where.not(readied_at: nil) }
  scope :nonready, -> { where(readied_at: nil)     }

  scope :active,   -> { where(finished_at: nil, forfeited_at: nil) }
  scope :inactive, -> { where(finished_at: nil, forfeited_at: nil) }

  scope :ghosts,    -> { where(ghost: true)  }
  scope :nonghosts, -> { where(ghost: false) }

  scope :unfinished, ->  { where(finished_at: nil)  }
  scope :unforfeited, -> { where(forfeited_at: nil) }

  # Filters entries to only those which came in first place in their respective races. This is a far less expensive way
  # than using Entry#place.
  scope :first_place, -> do
    joins('LEFT JOIN entries coentries ON entries.race_id = coentries.race_id AND entries.finished_at > coentries.finished_at')
      .where('coentries.finished_at IS NULL')
      .where('entries.finished_at IS NOT NULL')
  end

  # Returns this race's entry for the given user, not including ghosts.
  def self.find_for(user)
    find_by(runner: user, ghost: false)
  end

  def ready?
    readied_at.present?
  end

  def finished?
    finished_at.present?
  end

  def forfeited?
    forfeited_at.present?
  end

  def done?
    finished? || forfeited?
  end

  # TODO: This is expensive for how often it gets called (see app/views/race/_entries_table.slim); can we improve?
  def place
    return nil unless finished?

    race.entries.order(finished_at: :asc).pluck(:id).index(id) + 1
  end

  def duration
    return Duration.new((finished_at  - race.started_at) * 1000) if finished?
    return Duration.new((forfeited_at - race.started_at) * 1000) if forfeited?

    Duration.new(nil)
  end

  private

  def validate_destroy
    return unless race.started?

    errors[:base] << 'Cannot leave race once it has started'
    throw(:abort)
  end
end
