class Segment < ActiveRecord::Base
  belongs_to :run_file

  def gold?
    real_duration == best_real_duration || game_duration == best_game_duration
  end

  def skipped?
    real_duration == 0
  end

  def real_finish_time
    run_file.segments.select { |segment| segment.order <= order }.sum(&:real_duration)
  end

  def game_finish_time
    run_file.segments.select { |segment| segment.order <= order }.sum(&:game_duration)
  end
end
