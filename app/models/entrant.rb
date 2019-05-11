class Entrant < ApplicationRecord
  belongs_to :raceable, polymorphic: true, touch: true
  belongs_to :user

  validates_with EntrantValidator
  before_destroy :validate_destroy

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

    Duration.new((finished_at - raceable.started_at) * 1000).format
  end

  private

  def validate_destroy
    return unless raceable.started?

    errors[:base] << 'Cannot leave race in progress'
    errors[:status_message] << 'race_started_error'
    throw(:abort)
  end
end
