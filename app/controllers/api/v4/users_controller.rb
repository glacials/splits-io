class Api::V4::UsersController < Api::V4::ApplicationController
  before_action :set_user, only: [:show]

  def show
    render json: @user, serializer: Api::V4::UserSerializer
  end

  private

  def set_user
    @user = User.find_by!(name: params[:id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:user, params[:id])
  end
end
