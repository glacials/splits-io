class Runs::StatsController < Runs::ApplicationController
  before_action :set_run, only: [:index]

  def index
    gon.run = {id: @run.id, splits: @run.collapsed_splits}
    gon.scale_to = @run.time
  end
end
