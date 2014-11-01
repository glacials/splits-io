class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show]

  SAFE_PARAMS = [:name, :twitch_id]

  def index
    if search_params.empty?
      render status: 400, json: {
        status: 400,
        error: "You must supply one of the following parameters: #{SAFE_PARAMS.join(", ")}"
      }
      return
    end
    @users = User.where search_params
    render json: @users
  end

  def show
    render json: @user
  end

  private

  def set_user
    @user = User.find params[:id]
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {
      status: 404,
      error: "User with id '#{params[:id]}' not found. If '#{params[:id]}' isn't a numeric id, first use GET #{api_v1_users_url}"
    }
  end

  def search_params
    params.permit SAFE_PARAMS
  end
end
