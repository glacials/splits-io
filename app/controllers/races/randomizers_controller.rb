class Races::RandomizersController < Races::ApplicationController
  def show
    render 'races/show'
  end

  def update
    render :unauthorized unless @race.owner == current_user
    render :forbidden if @race.started?

    @race.attachments.attach(params[:randomizer][:files])
    Api::V1::RaceChannel.broadcast_to(@race, Api::V1::WebsocketMessageBlueprint.render_as_hash(
      Api::V1::WebsocketMessage.new('new_attachment', {
        message: 'The race owner has attached a new file',
        race: Api::V4::RaceBlueprint.render_as_hash(@race, view: @race.type),
        attachments_html: ApplicationController.render(partial: 'races/attachments', locals: {race: @race})
      })
    ))
  end

  private

  def set_race
    @race = Randomizer.find(params[:race])
  end
end
