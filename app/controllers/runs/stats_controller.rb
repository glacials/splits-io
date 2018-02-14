class Runs::StatsController < Runs::ApplicationController
  before_action :set_run, only: [:index, :run_history_csv, :segment_history_csv]

  def index
    timing = params[:timing] || @run.default_timing
    @run.parse_into_db unless @run.parsed?

    # Catch bad runs
    if @run.timer.nil?
      render 'runs/cant_parse', status: 500
    end

    gon.run = {
      id: @run.id36,
      segments: @run.segments.includes(:histories).map do |segment|
        {
          name: segment.name,
          duration_ms: segment.duration_ms(timing),
          shortest_duration_ms: segment.shortest_duration_ms(timing),
          histories: segment.histories.map do |history|
            {
              duration_ms: history.duration_ms(timing)
            }
          end
        }
      end,
      history: @run.histories.select(:id, :attempt_number, :realtime_duration_ms, :gametime_duration_ms),
      attempts: @run.attempts,
      program: @run.program
    }
  end

  def run_history_csv
    @run.parse_into_db unless @run.parsed?

    column_names = ['Attempt #', 'Realtime (ms)', 'Gametime (ms)']

    csv = CSV.generate do |doc|
      doc << column_names
      @run.histories.each do |history|
        doc << [history.attempt_number, history.realtime_duration_ms, history.gametime_duration_ms]
      end
    end

    send_data(csv, filename: "#{@run.id36}_run_history.csv", layout: false)
  end

  def segment_history_csv
    @run.parse_into_db unless @run.parsed?

    if @run.attempts.nil? || @run.attempts.zero?
      redirect_to run_stats_path(@run), alert: 'Segment history is not available for this run.'
      return
    end

    csv = CSV.generate do |doc|
      header = ['Segment name']

      if @run.segments.empty? || @run.segments.first.histories.empty?
        attempts = 0
      else
        attempts = @run.segments.first.histories.order(attempt_number: :asc).last.attempt_number
      end

      (1..attempts).each do |attempt_number|
        header << "Attempt ##{attempt_number}'s Duration (ms)"
      end
      doc << header

      @run.segments.order(segment_number: :asc).includes(:histories).each do |segment|
        row = []
        row << segment.name
        next if segment.histories.empty?

        attempt_number = 1
        segment.histories.order(attempt_number: :asc).each do |h|
          while h.attempt_number > attempt_number
            row << ''
            attempt_number += 1
          end
          row << h.duration_ms(Run::REAL)
          attempt_number += 1
        end
        doc << row
      end
    end

    send_data(csv, filename: "#{@run.id36}_segment_history.csv", layout: false)
  end
end
