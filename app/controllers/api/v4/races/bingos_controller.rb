class Api::V4::Races::BingosController < Api::V4::Races::ApplicationController
  def index
    render json: Api::V4::RaceBlueprint.render(@races, view: :bingo)
  end

  def create
    bingo = Bingo.new(bingo_params)
    bingo.owner = current_user
    if bingo.save
      render status: :created, json: Api::V4::RaceBlueprint.render(bingo, root: :bingo, view: :bingo, join_token: true)
    else
      render status: :bad_request, json: {
        status: :bad_request,
        error:  bingo.errors.full_messages.to_sentence
      }
    end
  end

  def show
    render json: Api::V4::RaceBlueprint.render(@race, root: :bingo, view: :bingo, chat: true)
  end

  def update
    # TODO: update bingo card url
  end

  private

  def set_races
    super(Bingo)
  end

  def set_race
    super(Bingo)
  end

  def bingo_params
    params.permit(:game_id, :visibility, :notes, :card_url)
  end
end
