class Api::V4::RaceBroadcastJob < ApplicationJob
  queue_as :v4_race_broadcast

  def perform(race, status, message)
    msg = {
      message: message,
      race:    Api::V4::RaceBlueprint.render_as_hash(race, view: race.type)
    }
    onsite_msg = {
      message:       'Updated html',
      entrants_html: ApplicationController.render(partial: 'races/entrants_table', locals: {race: race}),
      stats_html:    ApplicationController.render(partial: 'races/stats', locals: {race: race})
    }
    if race.randomizer?
      onsite_msg[:attachments_html] = ApplicationController.render(partial: 'races/attachments', locals: {race: race})
    end

    ws_msg = Api::V4::WebsocketMessage.new(status, msg)
    ws_onsite_msg = Api::V4::WebsocketMessage.new("#{status}:html", onsite_msg)
    Api::V4::RaceChannel.broadcast_to(race, Api::V4::WebsocketMessageBlueprint.render_as_hash(ws_msg))
    ActionCable.server.broadcast(
      "api:v4:race:#{race.to_gid_param}:onsite",
      Api::V4::WebsocketMessageBlueprint.render_as_hash(ws_onsite_msg)
    )
  end
end
