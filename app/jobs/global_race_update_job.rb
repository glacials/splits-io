class GlobalRaceUpdateJob < ApplicationJob
  queue_as :global_race_update

  def perform(status, message, race)
    ws_msg = Api::V1::WebsocketMessage.new(
      status,
      message: message,
      race:    Api::V4::RaceBlueprint.render_as_hash(race, view: race.type)
    )
    ActionCable.server.broadcast(
      'v1:global_updates_channel',
      race: Api::V1::WebsocketMessageBlueprint.render_as_hash(ws_msg)
    )
  end
end
