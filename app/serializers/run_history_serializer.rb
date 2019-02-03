class RunHistorySerializer < Panko::Serializer
  attributes :attempt_number, :realtime_duration_ms, :gametime_duration_ms
end
