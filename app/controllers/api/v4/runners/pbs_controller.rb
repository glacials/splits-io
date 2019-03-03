class Api::V4::Runners::PbsController < Api::V4::ApplicationController
  before_action :set_runner
  before_action :set_pbs, only: [:index]

  def index
    pbs = paginate @pbs
    render json: RunBlueprint.render(pbs, view: :api_v4, root: :pbs, toplevel: :run)
  end

  private

  def set_pbs
    @pbs = @runner.pbs.includes(:game, :category)
  end
end
