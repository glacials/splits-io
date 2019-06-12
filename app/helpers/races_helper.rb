module RacesHelper
  def statcard_class(race)
    case race.status
    when 'open'
      'bg-success'
    when 'in_progress'
      'bg-warning'
    when 'ended'
      'bg-secondary'
    else
      raise 'invalid status'
    end
  end

  def entrant_color(entrant)
    if entrant.forfeited?
      'text-danger'
    elsif entrant.finished?
      'text-success'
    else
      ''
    end
  end

  def entrant_place(entrant)
    if entrant.forfeited?
      icon('fas', 'times')
    elsif entrant.finished?
      entrant.place.ordinalize
    else
      '-'
    end
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
