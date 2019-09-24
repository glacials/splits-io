class Api::V4::RunHistoryBlueprint < Blueprinter::Base
  fields :id, :attempt_number, :realtime_duration_ms, :gametime_duration_ms

  field(:started_at_ms) { |history, _| history.started_at.to_f * 1000 }
  field(:ended_at_ms) { |history, _| history.ended_at.to_f * 1000 }
end
