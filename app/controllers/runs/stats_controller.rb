class Runs::StatsController < Runs::ApplicationController
  before_action :set_run, only: [:index, :csv]

  def index
    @run.parse(fast: false)
    @raw_splits = @run.parse(fast: false)[:splits]
    gon.run = {
      id: @run.id36,
      splits: @run.collapsed_splits,
      raw_splits: @raw_splits,
      history: @run.history,
      attempts: @run.attempts,
      program: @run.program,
    }
    gon.scale_to = @run.time
  end

  def csv
    @raw_splits = @run.parse(fast: false)[:splits]

    column_names = ['name']
    segment_histories = {}

    csv = CSV.generate do |csv|
      segment_no = 0
      @raw_splits.each do |segment|
        column_names << segment.name
        segment.indexed_history.each do |attempt_no, duration|
          segment_histories[attempt_no] ||= {}
          segment_histories[attempt_no][segment_no] = duration
        end
        segment_no += 1
      end

      num_segments = segment_histories.map { |h| h[1].length }.max

      csv << column_names

      segment_histories.each do |attempt_no, segments|
        if segments.length != num_segments
          next
        end

        csv << segments.values
      end
    end

    send_data(csv, filename: "#{@run.id36}.csv", layout: false)
  end
end
