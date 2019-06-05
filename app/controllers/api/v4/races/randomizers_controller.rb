class Api::V4::Races::RandomizersController < Api::V4::Races::ApplicationController
  def index
    render json: Api::V4::RaceBlueprint.render(@races, view: :randomizer)
  end

  def create
    rando = Randomizer.new(randomizer_params)
    rando.owner = current_user
    if rando.save
      render status: :created, json: Api::V4::RaceBlueprint.render(
        rando,
        root: :randomizer,
        view: :randomizer,
        join_token: true,
      )
    else
      render status: :bad_request, json: {
        status: :bad_request,
        error:  rando.errors.full_messages.to_sentence
      }
    end
  end

  def show
    render json: Api::V4::RaceBlueprint.render(@race, root: :randomizer, view: :randomizer, chat: true)
  end

  def update
    # TODO: port from internal only controller
  end

  private

  def set_races
    super(Randomizer)
  end

  def set_race
    super(Randomizer)
  end

  def randomizer_params
    params.permit(:game_id, :visibility, :notes, :seed)
  end
end
