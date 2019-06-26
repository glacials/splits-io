class Api::V4::RaceableBroadcastJob < ApplicationJob
  queue_as :v4_raceable_broadcast

  def perform(raceable, status, message)
    msg = {
      message:  message,
      raceable: Api::V4::RaceBlueprint.render_as_hash(raceable, view: raceable.type)
    }
    onsite_msg = {
      message:      'Updated html',
      entries_html: ApplicationController.render(partial: 'races/entries_table', locals: {race: raceable}),
      stats_html:   ApplicationController.render(partial: 'races/stats', locals: {race: raceable})
    }
    if raceable.randomizer?
      onsite_msg[:attachments_html] = ApplicationController.render(partial: 'races/attachments', locals: {race: raceable})
    end

    ws_msg = Api::V4::WebsocketMessage.new(status, msg)
    ws_onsite_msg = Api::V4::WebsocketMessage.new("#{status}:html", onsite_msg)
    Api::V4::RaceableChannel.broadcast_to(raceable, ws_msg.to_h)
    ActionCable.server.broadcast("api:v4:raceable:#{raceable.to_gid_param}:onsite", ws_onsite_msg.to_h)
  end
end
