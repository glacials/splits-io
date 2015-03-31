class Api::V4::Users::PbsController < Api::V4::ApplicationController
  before_action :set_user
  before_action :set_pbs, only: [:index]

  def index
    paginate json: @pbs, each_serializer: Api::V4::RunSerializer
  end

  private

  def set_user
    @user = User.find_by(name: params[:user_id]) || User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:user, params[:user_id])
  end

  def set_pbs
    @pbs = @user.pbs.includes(:game, :category)
  end
end
