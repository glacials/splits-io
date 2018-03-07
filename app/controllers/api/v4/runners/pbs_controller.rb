class Api::V4::Runners::PbsController < Api::V4::ApplicationController
  before_action :set_runner
  before_action :set_pbs, only: [:index]

  def index
    paginate json: @pbs, each_serializer: Api::V4::RunSerializer, root: 'pbs'
  end

  private

  def set_pbs
    @pbs = @runner.pbs.includes(:game, :category)
  end
end
