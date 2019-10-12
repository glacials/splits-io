class Api::V4::SegmentBlueprint < Blueprinter::Base
  fields :id, :segment_number, :name,
         :realtime_shortest_duration_ms, :realtime_gold, :realtime_reduced, :realtime_skipped,
         :gametime_shortest_duration_ms, :gametime_gold, :gametime_reduced, :gametime_skipped,
         :display_name

  association :histories, blueprint: Api::V4::SegmentHistoryBlueprint, if: ->(_, _, options) { options[:historic] }

  # API v4 promises non-null for these fields
  field(:realtime_start_ms)    { |run, _| run.realtime_start_ms    || 0 }
  field(:realtime_end_ms)      { |run, _| run.realtime_end_ms      || 0 }
  field(:realtime_duration_ms) { |run, _| run.realtime_duration_ms || 0 }
  field(:gametime_start_ms)    { |run, _| run.gametime_start_ms    || 0 }
  field(:gametime_end_ms)      { |run, _| run.gametime_end_ms      || 0 }
  field(:gametime_duration_ms) { |run, _| run.gametime_duration_ms || 0 }
end
