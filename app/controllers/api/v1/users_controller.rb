class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show]

  SAFE_PARAMS = [:name, :twitch_id]

  def index
    if search_params.empty?
      render status: 400, json: {
        status: 400,
        message: "You must supply one of the following parameters: #{SAFE_PARAMS.join(", ")}"
      }
      return
    end
    @users = User.where search_params
    render json: @users.pluck(:id)
  end

  def show
    render json: @user
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def search_params
    params.permit SAFE_PARAMS
  end
end
