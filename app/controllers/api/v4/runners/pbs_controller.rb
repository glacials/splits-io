class Api::V4::Runners::PbsController < Api::V4::ApplicationController
  before_action :set_runner
  before_action :set_pbs, only: [:index]

  def index
    paginate  json: @pbs,
              each_serializer: Api::V4::RunSerializer,
              root: 'pbs',
              include: %w[game category runners segments]
  end

  private

  def set_pbs
    @pbs = @runner.pbs.includes(:game, :category)
  end
end
