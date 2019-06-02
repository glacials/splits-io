class Api::V4::Races::RacesController < Api::V4::Races::ApplicationController
  def index
    render json: Api::V4::RaceBlueprint.render(@races, view: :race)
  end

  def create
    race = Race.new(race_params)
    race.owner = current_user
    if race.save
      render status: :created, json: Api::V4::RaceBlueprint.render(race, root: :race, view: :race, join_token: true)
    else
      render status: :bad_request, json: {
        status: :bad_request,
        error:  race.errors.full_messages.to_sentence
      }
    end
  end

  def show
    render json: Api::V4::RaceBlueprint.render(@race, root: :race, view: :race, chat: true)
  end

  def update
    # TODO: maybe remove?
  end

  private

  def set_races
    super(Race)
  end

  def set_race
    super(Race)
  end

  def race_params
    params.permit(:category_id, :visibility, :notes)
  end
end
