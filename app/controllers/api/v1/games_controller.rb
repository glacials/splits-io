class Api::V1::GamesController < Api::V1::ApplicationController
  def index
    render json: @records
  end

  def show
    render json: @record
  end

  private

  def safe_params
    [:name, :shortname]
  end

  def model
    Game
  end
end
