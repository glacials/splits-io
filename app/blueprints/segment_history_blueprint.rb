class SegmentHistoryBlueprint < Blueprinter::Base
  identifier :id
  fields :attempt_number

  field :realtime_duration_ms do |history, _options|
    history.realtime_duration_ms || 0
  end

  field :gametime_duration_ms do |history, _options|
    history.gametime_duration_ms || 0
  end
end
