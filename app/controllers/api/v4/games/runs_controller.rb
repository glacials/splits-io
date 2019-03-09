class Api::V4::Games::RunsController < Api::V4::ApplicationController
  before_action :set_game, only: [:index]
  before_action :set_runs, only: [:index]

  def index
    runs = paginate @runs
    render json: Api::V4::RunBlueprint.render(runs, root: :runs, toplevel: :run)
  end

  private

  def set_runs
    @runs = @game.runs.includes(:game, :category, :user, :segments)
  end
end
