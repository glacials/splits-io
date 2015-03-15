class Api::V4::Users::RunsController < Api::V4::ApplicationController
  before_action :set_user
  before_action :set_runs, only: [:index]

  def index
    paginate json: @runs, each_serializer: class.parent::RunSerializer
  end

  private

  def set_runs
    @runs = @user.runs.includes(:game, :category)
  end
end
