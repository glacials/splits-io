class Api::V3::Users::PbsController < Api::V3::ApplicationController
  before_action :set_user
  before_action :set_pbs, only: [:index]

  def index
    render json: @pbs, each_serializer: Api::V3::RunSerializer
  end

  private

  def set_user
    @user = User.find_by(name: params[:user_id]) || User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {status: 404, message: "User with name or id '#{params[:user_id]}' not found."}
  end

  def set_pbs
    @pbs = @user.pbs
  end
end
