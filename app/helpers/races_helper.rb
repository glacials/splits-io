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

  # Overrides the default helper because Race#to_param returns a user-friendly ID
  def api_v4_race_path(race)
    super(race.id)
  end
end
