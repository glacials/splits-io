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
end
