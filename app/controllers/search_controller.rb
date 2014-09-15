class SearchController < ApplicationController
  def index
    if params[:q]
      @query = params[:q].strip
      @result = {
        users: User.search(@query),
        games: Game.search(@query),
        runs: Run.joins(:category).where(categories: {game_id: Game.search(@query)})
      }
    end
  end
end
