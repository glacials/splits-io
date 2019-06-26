class Api::V4::Raceables::BingosController < Api::V4::Raceables::ApplicationController
  before_action :check_params, only: %i[update]

  def index
    super(@raceables, Bingo)
  end

  def create
    bingo = Bingo.new(bingo_params)
    super(bingo)
  end

  def show
    super(@raceable)
  end

  def update
    if @raceable.update(card_url: params[:card_url])
      render status: :ok, json: Api::V4::RaceBlueprint.render(@raceable, view: :bingo, root: :bingo)
      Api::V4::RaceableBroadcastJob.perform_later(@raceable, 'new_card', 'The bingo card has been updated')
    else
      render status: :bad_request, json: {
        status: 400,
        error:  @raceable.errors.full_messages.to_sentence
      }
    end
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

  def check_params
    if @raceable.started?
      render status: :conflict, json: {
        status: 409,
        error:  'Cannot update randomizer after it has started'
      }
      return
    end

    params.require(:card_url)
  rescue ActionController::ParameterMissing
    render status: :bad_request, json: {
      status: 400,
      error:  'Parameter "card_url" cannot be blank'
    }
  end
end
