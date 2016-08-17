class Runs::StatsController < Runs::ApplicationController
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
    }
    gon.scale_to = @run.time

  end
end
