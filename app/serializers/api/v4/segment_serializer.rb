class Api::V4::SegmentSerializer < Api::V4::ApplicationSerializer
  attributes  :id, :name, :segment_number,
              :realtime_start_ms, :realtime_end_ms, :realtime_duration_ms, :realtime_shortest_duration_ms,
              :realtime_gold, :realtime_reduced, :realtime_skipped,
              :gametime_start_ms, :gametime_end_ms, :gametime_duration_ms, :gametime_shortest_duration_ms,
              :gametime_gold, :gametime_reduced, :gametime_skipped

  has_many :histories, serializer: Api::V4::SegmentHistorySerializer
end
