class Api::V4::Runs::SplitsController < Api::V4::ApplicationController
  before_action :set_run

  def index
    render json: @run.splits, each_serializer: Api::V4::SplitSerializer
  end
end
