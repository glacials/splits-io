class SearchController < ApplicationController
  def index
    if params[:q]
      @query = params[:q].strip
      @result = {
        users: User.search(@query),
        games: Game.search(@query)
      }
      if @result[:games].length == 1
        @result[:runs] = Run.joins(:category).where(categories: {game_id: @result[:games]})
      end
    end
  end
end
