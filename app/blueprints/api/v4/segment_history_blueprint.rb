class Api::V4::SegmentHistoryBlueprint < Blueprinter::Base
  fields :attempt_number

  field :realtime_duration_ms do |history, _|
    history.realtime_duration_ms || 0
  end

  field :gametime_duration_ms do |history, _|
    history.gametime_duration_ms || 0
  end
end
