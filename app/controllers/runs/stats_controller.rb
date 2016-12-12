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

    send_data(csv, filename: "#{@run.id36}.csv", layout: false)
  end
end
