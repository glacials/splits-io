class Api::V2::GamesController < Api::V2::ApplicationController
  def index
    render json: @records, each_serializer: Api::V2::GameSerializer
  end

  def show
    render json: @record, serializer: Api::V2::GameSerializer
  end

  private

  def safe_params
    [:id, :name, :shortname]
  end

  def model
    Game
  end
end
