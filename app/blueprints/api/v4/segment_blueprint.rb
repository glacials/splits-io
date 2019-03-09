class Api::V4::SegmentBlueprint < Blueprinter::Base
  fields :id, :segment_number, :name,
         :realtime_start_ms, :realtime_end_ms, :realtime_duration_ms, :realtime_shortest_duration_ms,
         :realtime_gold, :realtime_reduced, :realtime_skipped,
         :gametime_start_ms, :gametime_end_ms, :gametime_duration_ms, :gametime_shortest_duration_ms,
         :gametime_gold, :gametime_reduced, :gametime_skipped

  association :histories, blueprint: Api::V4::SegmentHistoryBlueprint, if: ->(_, options) { options[:historic] }
end
