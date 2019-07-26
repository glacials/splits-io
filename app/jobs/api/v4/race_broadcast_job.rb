class Api::V4::RaceBroadcastJob < ApplicationJob
  queue_as :v4_races

  def perform(race, status, message)
    msg = {
      message: message,
      race:    Api::V4::RaceBlueprint.render_as_hash(race)
    }
    onsite_msg = {
      message:          'Updated html',
      entries_html:     ApplicationController.render(partial: 'races/entries_table', locals: {race: race}),
      stats_html:       ApplicationController.render(partial: 'races/stats', locals: {race: race}),
      attachments_html: ApplicationController.render(partial: 'races/attachments', locals: {race: race})
    }

    ws_msg = Api::V4::WebsocketMessage.new(status, msg)
    ws_onsite_msg = Api::V4::WebsocketMessage.new("#{status}:html", onsite_msg)
    Api::V4::RaceChannel.broadcast_to(race, ws_msg.to_h)
    ActionCable.server.broadcast("api:v4:race:#{race.to_gid_param}:onsite", ws_onsite_msg.to_h)
  end
end
