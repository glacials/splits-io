class EntryValidator < ActiveModel::Validator
  def validate(record)
    # This needs to be before `if record.new_record?` so we can check if the entry is a ghost before we check if the
    # runner is joining multiple races. (Someone using my ghost shouldn't prevent me from joining a race.)
    if record.run_id_changed?
      begin
        run = Run.find(record.run_id)

        if run.completed?(Run::REAL) # If we are a ghost
          if record.race.belongs_to?(record.creator)
            record.assign_attributes(
              ghost: true,
              runner: run.user,
              readied_at: Time.now.utc
            )
          else
            record.errors[:base] << 'Only the race owner can add the ghost of a completed run'
          end
        end
      rescue ActiveRecord::RecordNotFound
        record.errors[:run_id] << 'No run with that ID exists'
      end
    end

    if record.new_record?
      # Reject new entry if race has already started
      if record.race.started?
        record.errors[:base] << 'Cannot join race that has already started'
      end

      # Reject if entry's user is in another active race
      if !record.ghost? && record.runner.in_race?
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
  end
end
