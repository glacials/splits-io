class Runs::GraphsController < Runs::ApplicationController
  before_action :set_run, only: [:index]

  def index
    @run.parse(fast: false)
    gon.run = {id: @run.id, splits: @run.collapsed_splits}
    gon.scale_to = @run.time
    gon.raw_run = {
      splits: @run.parse(fast: false)[:splits],
      history: @run.history,
      attempts: @run.attempts,
      program: @run.program
    }
  end
end
