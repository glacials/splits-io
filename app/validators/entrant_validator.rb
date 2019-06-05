class EntrantValidator < ActiveModel::Validator
  def validate(record)
    if record.new_record?
      # Reject new entrant if race has already started
      if record.raceable.started?
        record.errors[:base] << 'Cannot join race that has already started'
      end

      # Reject if entrant's user is in another active race
      if record.user.in_race?
        record.errors[:base] << 'Cannot join more than one race at a time'
      end
    end

    # Reject if ready status is changed on a started race
    if record.readied_at_changed? && record.raceable.started?
      type = record.readied_at.nil? ? 'unready' : 'ready'
      record.errors[:base] << "Cannot #{type} on a race that has already started"
    end

    # Reject finished_at changes on races that haven't started or have finished
    if record.finished_at_changed?
      type = record.finished_at.nil? ? 'rejoin' : 'finish'
      unless record.raceable.started?
        record.errors[:base] << "Cannot #{type} a race that hasn't started"
      end

      if record.raceable.finished?
        record.errors[:base] << "Cannot #{type} a race that is already completed"
      end

      # Ensure time is after race start time
      if record.finished_at.present? && record.raceable.started_at > record.finished_at
        record.errors[:base] << 'Finish time can not be before race start'
      end
    end

    # Reject forfeited_at changes on races that haven't started or have finished
    if record.forfeited_at_changed?
      type = record.forfeited_at.nil? ? 'rejoin' : 'forfeit'
      unless record.raceable.started?
        record.errors[:base] << "Cannot #{type} a race that hasn't started"
      end

      if record.raceable.finished?
        record.errors[:base] << "Cannot #{type} a race that is already completed"
      end

      # Ensure time is after the race start time
      if record.forfeited_at.present? && record.raceable.started_at > record.forfeited_at
        record.errors[:base] << 'Forfeit time can not be before race start'
      end
    end
  end
end
