module DurationsHelper
  # faster returns true if duration_a < duration_b. If the durations aren't comparable for any reason (e.g. one is nil),
  # default is returned.
  def faster?(duration_a, duration_b, default: false)
    duration_a < duration_b
  rescue
    default
  end
end
