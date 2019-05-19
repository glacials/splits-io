class Entrant < ApplicationRecord
  # On validation error, entrants will have the error key :status_message to indicate what went wrong with the request
  # to clients, this should be removed if you plan to display all error messages to users
  belongs_to :raceable, polymorphic: true, touch: true
  belongs_to :user

  validates_with EntrantValidator
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
    return '-' unless finished?
    return 'big fat x' if forfeited?

    raceable.entrants.order(finished_at: :asc).pluck(:id).index(id) + 1
  end

  def duration
    return Duration.new(nil) unless finished?

    Duration.new((finished_at - raceable.started_at) * 1000)
  end

  def error_status!
    errors.delete(:status_message).try(:first)
  end

  private

  def validate_destroy
    return unless raceable.started?

    errors[:base] << 'Cannot leave race once it has started'
    errors[:status_message] << 'race_started_error'
    throw(:abort)
  end
end
