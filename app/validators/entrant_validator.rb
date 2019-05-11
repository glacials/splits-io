class EntrantValidator < ActiveModel::Validator
  def validate(record)
    if record.new_record?
      if record.raceable.started?
        record.errors[:base] << 'Cannot join race that has already started'
        record.errors[:status_message] << 'race_started_error'
      end

      if record.user.in_race?
        record.errors[:base] << 'Cannot join more than one race at a time'
        record.errors[:status_message] << 'in_race_error'
      end
    end

    if record.readied_at_changed? && record.raceable.started?
      type = record.readied_at.nil? ? 'unready' : 'ready'
      record.errors[:base] << "Cannot #{type} on a race in progress"
      record.errors[:status_message] << 'race_started_error'
    end

    if record.finished_at_changed?
      type = record.finished_at.nil? ? 'rejoin' : 'finish'
      unless record.raceable.started?
        record.errors[:base] << "Cannot #{type} a race that hasn't started"
        record.errors[:status_message] << 'race_not_started_error'
      end

      if record.raceable.finished?
        record.errors[:base] << "Cannot #{type} a race that is already completed"
        record.errors[:status_message] << 'race_finished_error'
      end
    end
  end
end
