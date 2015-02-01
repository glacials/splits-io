class Api::V2::GamesController < Api::V2::ApplicationController
  def index
    render json: @records.includes(:categories), each_serializer: Api::V2::GameSerializer
  end

  def show
    render json: @record, serializer: Api::V2::GameSerializer
  end

  private

  def check_params
    super unless params[:fuzzyname]
  end

  def set_records
    @records = super.search(params[:fuzzyname])
  end

  def search_conditions
    super.except(:fuzzyname)
  end

  def safe_params
    [:id, :name, :shortname, :fuzzyname]
  end

  def model
    Game
  end
end
