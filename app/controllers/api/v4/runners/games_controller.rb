class Api::V4::Runners::GamesController < Api::V4::ApplicationController
  before_action :set_runner
  before_action :set_games, only: [:index]

  def index
    games = paginate @games
    render json: GameBlueprint.render(games, view: :api_v4, root: :games, toplevel: :game)
  end

  private

  def set_games
    @games = @runner.games.includes(:categories)
  end
end
