class Api::V4::Categories::RunsController < Api::V4::ApplicationController
  before_action :set_category, only: [:index]
  before_action :set_runs, only: [:index]

  def index
    paginate  json: @runs,
              each_serializer: Api::V4::RunSerializer,
              include: %w[game category runners segments],
              root: 'runs'
  end

  private

  def set_runs
    @runs = @category.runs.includes(:game, :category, :user, :segments)
  end
end
