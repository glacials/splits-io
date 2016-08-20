class Api::V4::Runs::SplitsController < Api::V4::ApplicationController
  before_action :set_run

  def index
    if params[:historic] == '1'
      render json: @run.parse(fast: false)[:splits]
    else
      render json: @run.parse[:splits]
    end
  end
end
