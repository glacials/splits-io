class Api::V4::Games::RunnersController < Api::V4::ApplicationController
  before_action :set_game, only: [:index]

  def index
    render json: UserBlueprint.render(@game.users, view: :api_v4, root: :runners)
  end
end
