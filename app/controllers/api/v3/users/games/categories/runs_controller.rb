class Api::V3::Users::Games::Categories::RunsController < Api::V3::ApplicationController
  before_action :set_user, only: [:index]
  before_action :set_game, only: [:index]
  before_action :set_category, only: [:index]
  before_action :set_runs, only: [:index]

  def index
    runs = paginate @runs
    render json: Api::V3::RunBlueprint.render(runs, root: :run)
  end

  private

  def set_user
    @user = User.find_by(name: params[:user_id]) || User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: {status: 404, message: "User with name or id '#{params[:user_id]}' not found."}
  end

  def set_game
    @game = Game.joins(:srdc).find_by(speedrun_dot_com_games: {shortname: params[:game_id]})
    @game ||= Game.find(params[:game_id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: {
      status:  404,
      message: "Game with shortname or id '#{params[:game_id]}' not found."
    }
  end

  def set_category
    @category = @game.categories.find(params[:category_id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: {
      status:  404,
      message: "Category with id '#{params[:category_id]}' not found for game '#{params[:game_id]}'."
    }
  end

  def set_runs
    @runs = @user.runs.where(category: @category)
  end
end
