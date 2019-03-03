class RunHistoriesBlueprint < Blueprinter::Base
  view :default do
    identifier :id
    fields :attempt_number, :realtime_duration_ms, :gametime_duration_ms
  end

  view :api_v4 do
    include_view :default
  end
end
