class Api::V4::Games::RunnersController < Api::V4::ApplicationController
  before_action :set_game, only: [:index]

  def index
    render json: @game.users, each_serializer: Api::V4::RunnerSerializer, root: 'runners'
  end
end
