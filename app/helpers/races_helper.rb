module RacesHelper
  def statcard_class(race)
    case
    when !race.started?
      'text-success'
    when race.in_progress?
      'text-warning'
    when race.finished?
      nil
    else
      raise 'invalid status'
    end
  end

  def entry_color(entry)
    if entry.forfeited?
      'text-danger'
    elsif entry.finished?
      case entry.place
      when 1
        return 'text-gold'
      when 2
        return 'text-silver'
      when 3
        return 'text-bronze'
      else
        return 'text-light'
      end
    else
      ''
    end
  end

  def entry_place(entry)
    if entry.forfeited?
      icon('fas', 'times')
    elsif entry.finished? && entry.finished_at < Time.now.utc
      entry.place.ordinalize
    else
      '-'
    end
  end

  # Overrides the default helper because Race#to_param returns a user-friendly ID
  def api_v4_race_path(race)
    super(race.id)
  end
end
