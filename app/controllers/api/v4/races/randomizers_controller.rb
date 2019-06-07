class Api::V4::Races::RandomizersController < Api::V4::Races::ApplicationController
  def index
    render json: Api::V4::RaceBlueprint.render(@raceables, view: :randomizer)
  end

  def create
    rando = Randomizer.new(randomizer_params)
    rando.owner = current_user
    if rando.save
      render status: :created, json: Api::V4::RaceBlueprint.render(
        rando,
        root:       :randomizer,
        view:       :randomizer,
        join_token: true
      )
    else
      render status: :bad_request, json: {
        status: :bad_request,
        error:  rando.errors.full_messages.to_sentence
      }
    end
  end

  def show
    render json: Api::V4::RaceBlueprint.render(@raceable, root: :randomizer, view: :randomizer, chat: true)
  end

  def update
    head :forbidden if @raceable.started?
    head :bad_request if params[:randomizer].blank?

    @raceable.attachments.attach(params[:randomizer][:attachments])
    Api::V4::RaceChannel.broadcast_to(@raceable, Api::V4::WebsocketMessageBlueprint.render_as_hash(
      Api::V4::WebsocketMessage.new('new_attachment', {
        message: 'The race owner has attached a new file',
        race: Api::V4::RaceBlueprint.render_as_hash(@raceable, view: @raceable.type),
        attachments_html: ApplicationController.render(partial: 'races/attachments', locals: {race: @race})
      })
    ))
  end

  private

  def set_raceables
    super(Randomizer)
  end

  def set_raceable
    super(Randomizer)
  end

  def randomizer_params
    params.permit(:game_id, :visibility, :notes, :seed)
  end
end
