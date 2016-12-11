class Runs::StatsController < Runs::ApplicationController
  before_action :set_run, only: [:index]

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
end
