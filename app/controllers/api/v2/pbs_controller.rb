class Api::V2::PbsController < Api::V2::ApplicationController
  before_filter :set_user
  before_filter :set_pbs
  before_filter :translate_game_to_categories

  skip_before_filter :check_params
  skip_before_filter :set_records

  def index
    render json: @pbs, each_serializer: Api::V2::RunSerializer
  end

  private

  def translate_game_to_categories
    if search_conditions[:game_id]
      @pbs = @pbs.where(category_id: Game.find(search_conditions[:game_id]).categories.pluck(:id))
    end
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {
      status: 404,
      error: "No game with id '#{params[:game_id]}' found.",
      suggestions: [
        "If #{params[:game_id]} is a game's shortname, do GET #{root_url}api/v2/games?shortname=#{params[:game_id]} for an id.",
        "If #{params[:game_id]} is a game's name, do GET #{root_url}api/v2/games?name=#{params[:game_id]} for an id.",
        "If #{params[:game_id]} is a search term, do GET #{root_url}api/v2/games?fuzzyname=#{params[:game_id]} for an id."
      ]
    }
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def run_url_helper
    Proc.new { |run| run_url(run) }
  end

  def safe_params
    [:game_id, :category_id]
  end

  def set_pbs
    @pbs = @user.pbs.where(search_conditions.except(:game_id))
  end
end
