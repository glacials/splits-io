class Api::V4::Games::RunnersController < Api::V4::ApplicationController
  before_action :set_game, only: [:index]

  def index
    render json: Api::V4::UserBlueprint.render(@game.users, root: :runners)
  end
end
