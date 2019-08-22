class Entry < ApplicationRecord
  belongs_to :race, touch: true
  belongs_to :runner, class_name: 'User', optional: true
  belongs_to :creator, class_name: 'User'
  belongs_to :run, dependent: :destroy, optional: true

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
