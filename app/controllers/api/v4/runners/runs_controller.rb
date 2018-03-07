class Api::V4::Runners::RunsController < Api::V4::ApplicationController
  before_action :set_runner
  before_action :set_runs, only: [:index]

  def index
    paginate json: @runs, each_serializer: Api::V4::RunSerializer
  end

  private

  def set_runs
    @runs = @runner.runs.includes(:game, :category)
  end
end
