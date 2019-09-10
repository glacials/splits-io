class Api::V3::Users::Games::Categories::PbsController < Api::V3::ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_game, only: [:show]
  before_action :set_category, only: [:show]
  before_action :set_pb, only: [:show]

  def show
    render json: Api::V3::RunBlueprint.render(@pb, root: :run)
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

  def set_pb
    timing = params[:timing] || Run::REAL
    if ![Run::REAL, Run::GAME].include?(timing)
      render status: :bad_request, json: {
        status: 401,
        message: 'Timing must be "real" or "game".',
      }
      return
    end

    @pb = @user.pb_for(timing, @category)
    return if @pb.present?

    render status: :not_found, json: {
      status:  404,
      message: "User '#{params[:user_id]}' does not run category '#{params[:category_id]}' for game '#{params[:game_id]}'."
    }
  end
end
