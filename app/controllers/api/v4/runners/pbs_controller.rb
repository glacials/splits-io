class Api::V4::Runners::PbsController < Api::V4::ApplicationController
  before_action :set_runner
  before_action :set_pbs, only: [:index]

  def index
    pbs = paginate @pbs
    render json: Api::V4::RunBlueprint.render(pbs, root: :pbs, toplevel: :run)
  end

  private

  def set_pbs
    @pbs = @runner.pbs.includes(:game, :category)
  end
end
