class SearchController < ApplicationController
  def index
    return if params[:q].blank?
    @query = params[:q].strip
    @result = {games: [Game.find_by(shortname: @query)]}
    if @result[:games][0].present?
      @result[:runs] = @result[:games][0].runs
    else
      @result = {
        users: User.search(@query),
        games: Game.search(@query)
      }
      @result[:runs] = Run.joins(:category).where(categories: {game_id: @result[:games]}).page(params[:page])
    end
    respond_to do |format|
      format.json { render json: @result }
      format.html { render :index }
    end
  end
end
