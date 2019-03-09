class Api::V3::SegmentBlueprint < Blueprinter::Base
  fields :name

  field :duration do |segment, _|
    (segment.realtime_duration_ms || 0).to_f / 1000
  end

  field :finish_time do |segment, _|
    (segment.realtime_end_ms || 0).to_f / 1000
  end

  field :best do |segment, _|
    {duration: (segment.realtime_shortest_duration_ms || 0).to_f / 1000}
  end

  field :history do |segment, _|
    segment.histories.map do |history|
      (history.realtime_duration_ms || 0).to_f / 1000
    end
  end

  field :gold do |segment, _|
    segment.realtime_gold?
  end

  field :skipped do |segment, _|
    segment.realtime_skipped?
  end

  field :reduced do |segment, _|
    segment.realtime_reduced?
  end
end
