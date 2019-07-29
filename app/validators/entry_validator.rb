class EntryValidator < ActiveModel::Validator
  def validate(record)
    # validate_run_id needs to be before `if record.new_record?` so we can check if the entry is a ghost before we check
    # if the runner is joining multiple races. (Someone using my ghost shouldn't prevent me from joining a race.)
    validate_run_id(record) if record.run_id_changed?
    validate_new_record(record) if record.new_record?
    validate_pre_start_race(record) unless record.race.started?
    validate_times(record)
    validate_in_progress_race(record) if record.race.in_progress?
    record.errors[:base] << 'Cannot modify entry in finished race' if record.race.finished?
  end

  private

  def validate_run_id(record)
    run = Run.find(record.run_id)
    return unless run.completed?(Run::REAL) # If we are a ghost

    record.assign_attributes(
      ghost:      true,
      runner:     run.user,
      readied_at: Time.now.utc
    )
  rescue ActiveRecord::RecordNotFound
    record.errors[:run_id] << 'No run with that ID exists'
  end

  def validate_new_record(record)
    # Reject new entry if race has already started
    if record.race.started?
      record.errors[:base] << 'Cannot join race that has already started'
    end

    # Reject if entry's user is in another active race
    if !record.ghost? && record.runner.in_race?
      record.errors[:base] << 'Cannot join more than one race at a time'
    end
  end

  # Rejects setting finish/forfeit times before a race starts
  def validate_pre_start_race(record)
    return unless record.finished_at_changed? || record.forfeited_at_changed?

    record.errors[:base] << 'Cannot finish/forfeit before a race starts'
  end

  # Rejects times before the race start time
  def validate_times(record)
    return unless record.race.started_at.present?

    [record.finished_at, record.forfeited_at].each do |time|
      next unless time.present? && time < record.race.started_at

      record.errors[:base] << "#{time} cannot be before race start time"
    end
  end

  def validate_in_progress_race(record)
    # Reject changing ready time after race has started
    if record.readied_at_changed?
      record.errors[:base] << 'Cannot change ready status once race has started'
    end

    # Reject both finished_at and forfeited_at being set
    if record.finished_at.present? && record.forfeited_at.present?
      record.errors[:base] << 'Cannot finish and forfeit from the same race'
    end
  end
end
