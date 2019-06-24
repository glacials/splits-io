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
    elsif entry.finished?
      entry.place.ordinalize
    else
      '-'
    end
  end

  def api_v4_randomizer_path(raceable)
    super(raceable.id)
  end

  def api_v4_chat_path(raceable)
    # We can't use standard path helpers here because Raceable#to_param uses the abbreviated ID, which the API doesn't
    # support.
    case raceable.type
    when :bingo
      api_v4_bingo_chat_path(raceable.id)
    when :race
      api_v4_race_chat_path(raceable.id)
    when :randomizer
      api_v4_randomizer_chat_path(raceable.id)
    end
  end
end
