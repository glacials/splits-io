class SegmentBlueprint < Blueprinter::Base
  view :default do
    field :name
  end

  view :api_v4 do
    include_view :default

    fields :id, :segment_number,
           :realtime_start_ms, :realtime_end_ms, :realtime_duration_ms, :realtime_shortest_duration_ms,
           :realtime_gold, :realtime_reduced, :realtime_skipped,
           :gametime_start_ms, :gametime_end_ms, :gametime_duration_ms, :gametime_shortest_duration_ms,
           :gametime_gold, :gametime_reduced, :gametime_skipped

    association :histories, blueprint: SegmentHistoryBlueprint, if: ->(_segment, options) { options[:historic] }
  end

  view :api_v3 do
    include_view :default

    field :duration do |segment, _options|
      (segment.realtime_duration_ms || 0).to_f / 1000
    end

    field :finish_time do |segment, _options|
      (segment.realtime_end_ms || 0).to_f / 1000
    end

    field :best do |segment, _options|
      {duration: (segment.realtime_shortest_duration_ms || 0).to_f / 1000}
    end

    field :history do |segment, _options|
      segment.histories.map do |history|
        (history.realtime_duration_ms || 0).to_f / 1000
      end
    end

    field :gold do |segment, _options|
      segment.realtime_gold?
    end

    field :skipped do |segment, _options|
      segment.realtime_skipped?
    end

    field :reduced do |segment, _options|
      segment.realtime_reduced?
    end
  end
end
