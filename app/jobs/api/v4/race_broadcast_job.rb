class Api::V4::RaceBroadcastJob < ApplicationJob
  queue_as :v4_race_broadcast

  def perform(raceable, status, message)
    msg = {
      message: message,
      race:    Api::V4::RaceBlueprint.render_as_hash(raceable, view: raceable.type)
    }
    onsite_msg = {
      message:       'Updated html',
      entrants_html: ApplicationController.render(partial: 'races/entrants_table', locals: {race: raceable}),
      stats_html:    ApplicationController.render(partial: 'races/stats', locals: {race: raceable})
    }
    if raceable.randomizer?
      onsite_msg[:attachments_html] = ApplicationController.render(partial: 'races/attachments', locals: {race: raceable})
    end

    ws_msg = Api::V4::WebsocketMessage.new(status, msg)
    ws_onsite_msg = Api::V4::WebsocketMessage.new("#{status}:html", onsite_msg)
    Api::V4::RaceChannel.broadcast_to(raceable, ws_msg.to_h)
    ActionCable.server.broadcast("api:v4:race:#{raceable.to_gid_param}:onsite", ws_onsite_msg.to_h)
  end
end
