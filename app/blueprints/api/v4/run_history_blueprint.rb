class Api::V4::RunHistoryBlueprint < Blueprinter::Base
  fields :id, :attempt_number, :realtime_duration_ms, :gametime_duration_ms, :started_at, :ended_at
end
