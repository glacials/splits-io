class Runs::StatsController < Runs::ApplicationController
  before_action :set_run, only: [:index, :run_history_csv, :segment_history_csv]

  def index
    timing = params[:timing] || @run.default_timing
    @run.parse_into_activerecord unless @run.parsed?

    # Catch bad runs
    if @run.timer.nil?
      render 'runs/cant_parse', status: 500
    end

    segments = @run.segments.includes(:histories).map do |segment|
      segment.attributes.merge(history: segment.histories)
    end

    gon.run = {
      id: @run.id36,
      segments: @run.segments.map do |segment|
        {
          name: segment.name,
          duration_ms: segment.duration_ms(timing),
          shortest_duration_ms: segment.shortest_duration_ms(timing),
          histories: segment.histories.map do |history|
            {
              duration_ms: history.duration_ms(timing),
            }
          end,
        }
      end,
      history: @run.dynamodb_history,
      attempts: @run.attempts,
      program: @run.program
    }

    if @run.user.nil?
      gon.run['user'] = nil
    else
      gon.run['user'] = {
        id: @run.user.id,
        name: @run.user.name
      }
    end

    gon.scale_to = @run.duration_ms(timing)
  end

  def run_history_csv
    @run.parse_into_activerecord unless @run.parsed?

    column_names = @run.history.map.with_index do |_, i|
      "Run ##{i} (ms)"
    end

    csv = CSV.generate do |csv|
      csv << column_names
      csv << @run.history.map do |h|
        if h[:duration_seconds].nil?
          ""
        else
          (h[:duration_seconds] * 1000).truncate
        end
      end
    end

    send_data(csv, filename: "#{@run.id36}_run_history.csv", layout: false)
  end

  def segment_history_csv
    @run.parse_into_activerecord unless @run.parsed?

    if @run.attempts.nil? || @run.attempts == 0
      redirect_to run_stats_path(@run), alert: "Segment history is not available for this run."
      return
    end

    csv = CSV.generate do |csv|
      rows = []

      header = ['Segment name']
      (1..@run.attempts).each do |attempt_number|
        header << "Attempt ##{attempt_number} (ms)"
      end
      csv << header

      @run.segments.includes(:histories).each do |segment|
        row = []
        row << segment.name
        if segment.histories.empty?
          next
        end
        (1..@run.attempts).each do |attempt_number|
          h = segment.histories.find_by(attempt_number: attempt_number)
          if h.nil?
            row << ""
            next
          end

          row << h.duration_milliseconds
        end
        csv << row
      end
    end

    send_data(csv, filename: "#{@run.id36}_segment_history.csv", layout: false)
  end
end
