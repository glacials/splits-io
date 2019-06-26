class Api::V4::Raceables::RandomizersController < Api::V4::Raceables::ApplicationController
  before_action :check_params, only: %i[update]

  def index
    super(@raceables, Randomizer)
  end

  def create
    rando = Randomizer.new(randomizer_params)
    super(rando)
  end

  def show
    super(@raceable)
  end

  def update
    if @raceable.attachments.attach(params[:randomizer][:attachments])
      render json: Api::V4::RaceBlueprint.render(@raceable, view: :randomizer, root: :randomizer)
      Api::V4::RaceableBroadcastJob.perform_later(@raceable, 'new_attachment', 'The race owner has attached a new file')
    else
      render status: :bad_request, json: {
        status: 400,
        error:  @raceable.errors.full_messages.to_sentence
      }
    end
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

  def check_params
    if @raceable.started?
      render status: :conflict, json: {
        status: 409,
        error:  'Cannot update randomizer after it has started'
      }
      return
    end

    if params[:randomizer].blank?
      render status: :bad_request, json: {
        status: 400,
        error:  'Parameter "randomizer" cannot be blank'
      }
      return
    end
  end
end
