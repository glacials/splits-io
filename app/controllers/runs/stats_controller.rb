class Runs::StatsController < Runs::ApplicationController
  before_action :set_run, only: [:index, :run_history_csv, :segment_history_csv]

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

    column_names = ['segment name']
    segment_histories = []

    csv = CSV.generate do |csv|
      @raw_splits.each do |segment|
        segment_histories << [segment.name].concat(segment.history)
      end

      (segment_histories.map(&:length).max - 1).times do |i|
        column_names << "logged segment ##{i + 1}"
      end

      csv << column_names
      segment_histories.each do |segment_history|
        csv << segment_history
      end
    end

    send_data(csv, filename: "#{@run.id36}_segment_history.csv", layout: false)
  end
end
