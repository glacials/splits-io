class Api::V2::UsersController < Api::V2::ApplicationController
  def index
    render json: @records, each_serializer: Api::V2::UserSerializer
  end

  def show
    render json: @record, serializer: Api::V2::UserSerializer
  end

  private

  def safe_params
    [:id, :twitch_id, :name]
  end

  def model
    User
  end
end
