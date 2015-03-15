class Api::V4::Games::RunsController < Api::V4::ApplicationController
  before_action :set_game, only: [:index]
  before_action :set_runs, only: [:index]

  def index
    paginate json: @runs, each_serializer: class.parent::RunSerializer
  end

  private

  def set_runs
    @runs = @game.runs.includes(:game, :category, :user)
  end
end
