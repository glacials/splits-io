class Runs::StatsController < Runs::ApplicationController
  before_action :set_run, only: [:index, :run_history_csv, :segment_history_csv]

  def index
    if params['reparse'] == '1'
      @run.clear_dynamodb_rows
      @run.parse_into_dynamodb
      redirect_to run_stats_path(@run)
      return
    end

    segments = @run.dynamodb_segments

    attempts = @run.dynamodb_info['attempts']

    gon.run = {
      id: @run.id36,
      splits: segments,
      raw_splits: @run.segments_with_history,
      history: @run.dynamodb_history,
      attempts: attempts,
      program: @run.program,
    }
    gon.scale_to = @run.time
  end

  def run_history_csv
    column_names = @run.history.map.with_index do |_, i|
      "run ##{i}"
    end

    csv = CSV.generate do |csv|
      csv << column_names
      csv << @run.history
    end

    send_data(csv, filename: "#{@run.id36}_run_history.csv", layout: false)
  end

  def segment_history_csv
    @raw_splits = @run.parse(fast: false)[:splits]

    segment_histories = []

    csv = CSV.generate do |csv|
      rows = []

      header = ['Segment name']
      (1..@run.attempts).each do |attempt_no|
        header << "Attempt ##{attempt_no}"
      end
      csv << header

      @raw_splits.each do |segment|
        row = []
        row << segment.name
        if segment.indexed_history.nil?
          next
        end
        (1..@run.attempts).each do |attempt_no|
          h = segment.indexed_history["#{attempt_no + 1}"]
          if h.nil?
            row << ""
            next
          end

          row << h
        end
        csv << row
      end
    end

    send_data(csv, filename: "#{@run.id36}_segment_history.csv", layout: false)
  end
end
