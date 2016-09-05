class Api::V4::Runners::GamesController < Api::V4::ApplicationController
  before_action :set_runner
  before_action :set_games, only: [:index]

  def index
    paginate json: @games, each_serializer: Api::V4::GameSerializer
  end

  private

  def set_games
    @games = @runner.games.includes(:categories)
  end
end
