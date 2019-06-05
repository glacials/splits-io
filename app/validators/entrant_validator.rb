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

    if record.finished_at_changed?
      # Reject finished_at changes on races that haven't started or have finished
      type = record.finished_at.nil? ? 'rejoin' : 'finish'
      unless record.raceable.started?
        record.errors[:base] << "Cannot #{type} a race that hasn't started"
      end

      if record.raceable.finished?
        record.errors[:base] << "Cannot #{type} a race that is already completed"
      end

      # Reject times before the race start time
      if record.finished_at.present? && record.raceable.started_at > record.finished_at
        record.errors[:base] << 'Finish time can not be before race start'
      end

      # Reject if `forfeited_at` is already set
      if record.finished_at.present? && record.forfeited_at.present?
        record.errors[:finished_at] << 'Canont finish a race you have already forfeited'
      end
    end

    if record.forfeited_at_changed?
      # Reject forfeited_at changes on races that haven't started or have finished
      type = record.forfeited_at.nil? ? 'rejoin' : 'forfeit'
      unless record.raceable.started?
        record.errors[:base] << "Cannot #{type} a race that hasn't started"
      end

      if record.raceable.finished?
        record.errors[:base] << "Cannot #{type} a race that is already completed"
      end

      # Reject times before the race start time
      if record.forfeited_at.present? && record.raceable.started_at > record.forfeited_at
        record.errors[:base] << 'Forfeit time can not be before race start'
      end

      # Reject if `finished_at` is already set
      if record.forfeited_at.present? && record.finished_at.present?
        record.errors[:forfeited_at] << 'Cannot forfeit a race you have already finished'
      end
    end
  end
end
