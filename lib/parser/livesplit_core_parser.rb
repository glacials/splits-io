begin
  require File.expand_path('LiveSplitCore', __dir__)
rescue LoadError
  raise 'Please follow the steps to install livesplit-core in the readme'
end

class Parser
  def self.parse(run, fast: false)
    parse_result = if run.is_a?(Integer)
                     # If integer, attempt to parse the file descriptor attached to the number
                     LiveSplitCore::Run.parse_file_handle(run, '', false)
                   else
                     # Assume run is already read into a string and parse from memory
                     LiveSplitCore::Run.parse(run, run.length, '', false)
                   end
    return nil unless parse_result.parsed_successfully

    program = parse_result.timer_kind

    program = ExchangeFormat.to_s if Run.program_from_attribute(:to_s, program).nil?

    if parse_result.is_generic_timer && !Run.program_from_attribute(:to_s, program).exchangeable?
      # We got a file in the exchange format, but the reported timer doesn't support the exchange format. Wipe the timer
      # to stop from serving the exchange format when a user asks to download the file in the source timer's format.
      program = ExchangeFormat.to_s
    end

    run = parse_result.unwrap

    run_object = {
      program: program,
      game: run.game_name,
      category: run.category_name,
      srdc_id: run.metadata.run_id,
      attempts: run.attempt_count,
      offset: run.offset.total_seconds,
      history: nil,
      indexed_history: nil,
      realtime_history: nil,
      splits: [],
      realtime_time: 0,
      gametime_time: 0
    }.tap { |run_tap| run_tap[:name] = "#{run_tap[:game]} #{run_tap[:category]}".strip }

    unless fast
      run_object[:history] = []
      run_object[:indexed_history] = {}
      run_object[:realtime_history] = []
      (0...run.attempt_history_len).each do |i|
        attempt = run.attempt_history_index(i)
        attempt_id = attempt.index.to_i
        time = attempt.time()

        run_object[:history] << {
          attempt_number: attempt_id,
          gametime_duration_ms: time.game_time.try(:total_seconds).try(:*, 1000) || 0,
          realtime_duration_ms: time.real_time.try(:total_seconds).try(:*, 1000) || 0
        }

        if time.real_time.try(:total_seconds).present?
          run_object[:indexed_history][attempt_id] = time.real_time.try(:total_seconds)
          run_object[:realtime_history] << time.real_time.try(:total_seconds)
        end
      end
    end

    (0...run.len).each do |i|
      segment = run.segment(i)
      split = Split.new
      split.name = segment.name

      split.realtime_end = segment.personal_best_split_time.real_time.try(:total_seconds) || 0
      split.realtime_duration = [0, split.realtime_end - run_object[:realtime_time]].max
      split.realtime_start = split.realtime_end - split.realtime_duration

      split.realtime_best = segment.best_segment_time.real_time.try(:total_seconds) || 0
      split.realtime_skipped = split.realtime_duration.zero?

      if split.realtime_duration.positive? && split.realtime_duration.round(5) <= split.realtime_best.try(:round, 5)
        split.realtime_gold = true
      else
        split.realtime_gold = false
      end

      if fast
        split.realtime_history = nil
        split.indexed_history  = nil
      else
        history_iterator = segment.segment_history.iter
        split.indexed_history  = {}
        split.realtime_history = []
        until (history_element = history_iterator.next).nil?
          history_element_id   = history_element.index
          history_element_time = history_element.time
          split.indexed_history[history_element_id] = {
            gametime: history_element_time.game_time.try(:total_seconds) || 0,
            realtime: history_element_time.real_time.try(:total_seconds) || 0
          }

          split.realtime_history << history_element_time.real_time.try(:total_seconds) || 0
        end
        history_iterator.dispose
      end

      split.gametime_end = segment.personal_best_split_time.game_time.try(:total_seconds) || 0
      split.gametime_duration = [0, split.gametime_end - run_object[:gametime_time]].max
      split.gametime_start = split.gametime_end - split.gametime_duration

      split.gametime_best = segment.best_segment_time.game_time.try(:total_seconds) || 0
      split.gametime_skipped = split.gametime_duration.zero?

      if split.gametime_duration.positive? && split.gametime_duration.round(5) <= split.gametime_best.try(:round, 5)
        split.gametime_gold = true
      else
        split.gametime_gold = false
      end

      run_object[:realtime_time] += split.realtime_duration if split.realtime_duration.present?
      run_object[:gametime_time] += split.gametime_duration if split.gametime_duration.present?
      run_object[:splits] << split
    end

    run.dispose
    run_object
  end
end
