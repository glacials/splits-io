class Api::V4::Runs::SplitsController < Api::V4::ApplicationController
  before_action :set_run

  def index
    if params[:historic] == '1'
      render json: @run.parse(fast: false)[:splits], each_serializer: Api::V4::SplitWithHistorySerializer
    else
      render json: @run.parse[:splits], each_serializer: Api::V4::SplitSerializer
    end
  end
end
