class Api::V4::Races::RandomizersController < Api::V4::Races::ApplicationController
  def index
    render json: Api::V4::RaceBlueprint.render(@raceables, view: :randomizer)
  end

  def create
    rando = Randomizer.new(randomizer_params)
    super(rando)
  end

  def show
    render json: Api::V4::RaceBlueprint.render(@raceable, root: :randomizer, view: :randomizer, chat: true)
  end

  def update
    if @raceable.started?
      head :forbidden
      return
    end

    if params[:randomizer].blank?
      head :bad_request
      return
    end

    @raceable.attachments.attach(params[:randomizer][:attachments])
    Api::V4::RaceBroadcastJob.perform_later(@raceable, 'new_attachment', 'The race owner has attached a new file')
  end

  private

  def set_raceable
    super(Randomizer)
  end

  def set_raceables
    super(Randomizer)
  end

  def randomizer_params
    params.permit(:game_id, :visibility, :notes, :seed)
  end
end
