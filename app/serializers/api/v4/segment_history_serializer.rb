class Api::V4::SegmentHistorySerializer < Api::V4::ApplicationSerializer
  attributes :attempt_number, :realtime_duration_ms, :gametime_duration_ms

  def realtime_duration_ms
    object.realtime_duration_ms || 0
  end

  def gametime_duration_ms
    object.gametime_duration_ms || 0
  end
end
