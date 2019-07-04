class EntryValidator < ActiveModel::Validator
  def validate(record)
    if record.new_record?
      # Reject new entry if race has already started
      if record.race.started?
        record.errors[:base] << 'Cannot join race that has already started'
      end

      # Reject if entry's user is in another active race
      if record.user.in_race?
        record.errors[:base] << 'Cannot join more than one race at a time'
      end
    end

    # Reject if ready status is changed on a started race
    if record.readied_at_changed? && record.race.started?
      type = record.readied_at.nil? ? 'unready' : 'ready'
      record.errors[:base] << "Cannot #{type} on a race that has already started"
    end

    if record.finished_at_changed?
      # Reject finished_at changes on races that haven't started or have finished
      type = record.finished_at.nil? ? 'rejoin' : 'finish'
      unless record.race.started?
        record.errors[:base] << "Cannot #{type} a race that hasn't started"
      end

      if record.race.finished?
        record.errors[:base] << "Cannot #{type} a race that is already completed"
      end

      # Reject times before the race start time
      if type == 'finish' && (record.race.started_at.nil? || record.race.started_at > record.finished_at)
        record.errors[:base] << 'Finish time can not be before race start'
      end

      # Reject if `forfeited_at` is already set
      if record.finished_at.present? && record.forfeited_at.present?
        record.errors[:finished_at] << 'Cannot finish a race you have already forfeited'
      end
    end

    if record.forfeited_at_changed?
      # Reject forfeited_at changes on races that haven't started or have finished
      type = record.forfeited_at.nil? ? 'rejoin' : 'forfeit'
      unless record.race.started?
        record.errors[:base] << "Cannot #{type} a race that hasn't started"
      end

      if record.race.finished?
        record.errors[:base] << "Cannot #{type} a race that is already completed"
      end

      # Reject times before the race start time
      if type == 'forfeit' && (record.race.started_at.nil? || record.race.started_at > record.forfeited_at)
        record.errors[:base] << 'Forfeit time can not be before race start'
      end

      # Reject if `finished_at` is already set
      if record.forfeited_at.present? && record.finished_at.present?
        record.errors[:forfeited_at] << 'Cannot forfeit a race you have already finished'
      end
    end

    if record.run_id_changed?
      if !record.run_id.nil? && Run.find(record.run_id).user != record.user
        record.errors[:run_id] << 'Run and Entry must be owned by the same user'
      end
    end
  end
end
