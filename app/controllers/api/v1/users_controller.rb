class Api::V1::UsersController < Api::V1::ApplicationController
  def index
    render json: @records
  end

  def show
    render json: @record
  end

  private

  def safe_params
    [:twitch_id, :name]
  end

  def model
    User
  end
end
