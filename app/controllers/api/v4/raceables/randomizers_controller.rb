class Api::V4::Raceables::RandomizersController < Api::V4::Raceables::ApplicationController
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
    Api::V4::RaceableBroadcastJob.perform_later(@raceable, 'new_attachment', 'The race owner has attached a new file')
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
