module RacesHelper
  def statcard_class(race)
    case race.status
    when 'open'
      'bg-success'
    when 'in_progress'
      'bg-warning'
    when 'ended'
      'bg-info'
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
end
