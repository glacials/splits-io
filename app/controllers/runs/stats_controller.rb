class Runs::StatsController < Runs::ApplicationController
  include RunsHelper
  before_action :set_run, only: [:index]

  def index
    @run.parse(fast: false)
    gon.run = {
      id: @run.id,
      splits: @run.collapsed_splits,
      raw_splits: @run.parse(fast: false)[:splits],
      history: @run.history,
      attempts: @run.attempts,
      program: @run.program,
      colors: GRAPH_COLORS
    }
    gon.scale_to = @run.time

  end
end
