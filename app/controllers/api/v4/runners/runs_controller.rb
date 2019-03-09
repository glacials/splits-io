class Api::V4::Runners::RunsController < Api::V4::ApplicationController
  before_action :set_runner
  before_action :set_runs, only: [:index]

  def index
    runs = paginate @runs
    render json: Api::V4::RunBlueprint.render(runs, root: :runs, toplevel: :runs)
  end

  private

  def set_runs
    @runs = @runner.runs.includes(:game, :category)
  end
end
