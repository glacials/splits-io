class Api::V4::Runners::PBsController < Api::V4::ApplicationController
  before_action :set_runner
  before_action :set_pbs, only: [:index]

  def index
    paginate json: @pbs, each_serializer: Api::V4::RunSerializer
  end

  private

  def set_pbs
    @pbs = @runner.pbs.includes(:game, :category)
  end
end
