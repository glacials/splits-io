class Api::V4::GlobalRaceableUpdateJob < ApplicationJob
  queue_as :v4_global_raceable_update

  def perform(raceable, status, message)
    ws_msg = Api::V4::WebsocketMessage.new(
      status,
      message:  message,
      raceable: Api::V4::RaceBlueprint.render_as_hash(raceable, view: raceable.type)
    )
    ActionCable.server.broadcast(
      'v4:global_raceable_channel',
      ws_msg.to_h
    )
  end
end
