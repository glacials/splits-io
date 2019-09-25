class Api::V4::RunHistoryBlueprint < Blueprinter::Base
  fields :id, :attempt_number, :realtime_duration_ms, :gametime_duration_ms, :started_at, :ended_at

  field(:started_at) do |history, _|
    if history.started_at
      history.started_at
    else
      DateTime.new(2013, 11, 13, 0, 0, 0)
    end
  end

  field(:ended_at) do |history, _|
    if history.ended_at
      history.ended_at
    elsif history.realtime_duration_ms
      DateTime.new(2013, 11, 13, 0, 0, 0) + (history.realtime_duration_ms / 1000.0).seconds
    else
      DateTime.new(2013, 11, 13, 0, 0, 0)
    end
  end
end
