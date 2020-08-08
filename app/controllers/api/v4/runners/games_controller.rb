class Api::V4::Runners::GamesController < Api::V4::ApplicationController
  before_action :set_runner
  before_action :set_games, only: [:index]

  def index
    games = paginate @games
    render json: Api::V4::GameBlueprint.render(games, root: :games, toplevel: :game)
  end

  private

  def set_games
    @games = @runner.games.includes(:srdc, categories: [:srdc])
  end
end
