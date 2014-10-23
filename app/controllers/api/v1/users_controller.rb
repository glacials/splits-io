class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    unless search_params.any? { |param| params.key?(param) }
      render status: 400, json: {
        status: 400,
        message: "You must supply one of the following parameters: #{search_params.join(", ")}"
      }
      return
    end
    @users = User.where params.permit(search_params)
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
    [:name, :twitch_id]
  end
end
