class SumOfBestRun
  include CompletedRun

  attr_accessor :id, :id36, :run

  delegate_missing_to :@run

  def initialize(original_run)
    self.id = original_run.id
    self.id36 = "#{original_run.id36}-sum-of-best"
    self.run = original_run
    self.run.segments.each do |segment|
      segment.gametime_duration_ms = segment.gametime_shortest_duration_ms
      segment.realtime_duration_ms = segment.realtime_shortest_duration_ms
    end
    self.run.gametime_duration_ms = gametime_duration_ms
    self.run.realtime_duration_ms = realtime_duration_ms
  end

  def gametime_duration_ms
    @gametime_duration_ms ||= segments.reject { |segment| segment.gametime_duration_ms.nil? }.sum(&:gametime_duration_ms)
  end

  def realtime_duration_ms
    @realtime_duration_ms ||= segments.reject { |segment| segment.realtime_duration_ms.nil? }.sum(&:realtime_duration_ms)
  end

  def segments_with_groups
    return @segments_with_groups if @segments_with_groups
    segment_game_end_time = 0
    segment_real_end_time = 0
    @segments_with_groups = run.segments_with_groups
    @segments_with_groups.map! do |segment_or_group|
      if segment_or_group.is_a?(Segment)
        segment_or_group.gametime_duration_ms = segment_or_group.gametime_shortest_duration_ms
        segment_or_group.realtime_duration_ms = segment_or_group.realtime_shortest_duration_ms
        segment_or_group
      elsif segment_or_group.is_a?(SegmentGroup)
        segment_or_group.segments.map! do |segment|
          segment.gametime_duration_ms = segment.gametime_shortest_duration_ms
          segment.realtime_duration_ms = segment.realtime_shortest_duration_ms
          segment_game_end_time += segment.gametime_duration_ms
          segment_real_end_time += segment.realtime_duration_ms
          segment.gametime_end_ms = segment_game_end_time
          segment.realtime_end_ms = segment_real_end_time
          segment
        end
        segment_or_group
      end
    end
  end

  def video
    nil
  end

  def self.where(params)
    Run.where(params).map { |run| SumOfBestRun.new(run) }
  end
end
