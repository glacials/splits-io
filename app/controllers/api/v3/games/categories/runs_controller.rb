class Api::V3::Games::Categories::RunsController < Api::V3::ApplicationController
  before_action :set_game, only: [:index]
  before_action :set_category, only: [:index]
  before_action :set_runs, only: [:index]

  def index
    paginate json: @runs, each_serializer: Api::V3::RunSerializer, root: :runs
  end

  private

  def set_game
    @game = Game.find_by(shortname: params[:game_id]) || Game.find(params[:game_id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {status: 404, message: "Game with shortname or id '#{params[:game_id]}' not found."}
  end

  def set_category
    @category = @game.categories.find(params[:category_id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {status: 404, message: "Category with id '#{params[:category_id]}' not found for game '#{params[:game_id]}'."}
  end

  def set_runs
    @runs = @category.runs.includes(:game, :category, :user)
  end
end
