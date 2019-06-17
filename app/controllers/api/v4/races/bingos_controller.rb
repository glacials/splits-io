class Api::V4::Races::BingosController < Api::V4::Races::ApplicationController
  def index
    render json: Api::V4::RaceBlueprint.render(@raceables, view: :bingo)
  end

  def create
    bingo = Bingo.new(bingo_params)
    super(bingo)
  end

  def show
    render json: Api::V4::RaceBlueprint.render(@raceable, root: :bingo, view: :bingo, chat: true)
  end

  def update
    # TODO: update bingo card url
  end

  private

  def set_raceable
    super(Bingo)
  end

  def set_raceables
    super(Bingo)
  end

  def bingo_params
    params.permit(:game_id, :visibility, :notes, :card_url)
  end
end
