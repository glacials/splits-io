class SearchController < ApplicationController
  def index
    if params[:q]
      @query = params[:q].strip
      @result = {games: [Game.find_by(shortname: @query)]}
      if @result[:games][0].present?
        @result[:runs] = @result[:games][0].runs
      else
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
end
