class Entry < ApplicationRecord
  # On validation error, entries will have the error key :status_message to indicate what went wrong with the request
  # to clients, this should be removed if you plan to display all error messages to users
  belongs_to :raceable, polymorphic: true, touch: true
  belongs_to :user
  belongs_to :run, dependent: :destroy, optional: true

  validates_with EntryValidator
  # Validators are not called before destroy's, so manually hook and prevent if race is started
  before_destroy :validate_destroy

  scope :ready,    -> { where.not(readied_at: nil) }
  scope :nonready, -> { where(readied_at: nil) }

  scope :active,   -> { where(finished_at: nil, forfeited_at: nil) }
  scope :inactive, -> { where(finished_at: nil, forfeited_at: nil) }

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

    raceable.entries.order(finished_at: :asc).pluck(:id).index(id) + 1
  end

  def duration
    return Duration.new((finished_at  - raceable.started_at) * 1000) if finished?
    return Duration.new((forfeited_at - raceable.started_at) * 1000) if forfeited?

    Duration.new(nil)
  end

  private

  def validate_destroy
    return unless raceable.started?

    errors[:base] << 'Cannot leave race once it has started'
    throw(:abort)
  end
end
