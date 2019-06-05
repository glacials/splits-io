class Api::V4::GlobalRaceUpdateJob < ApplicationJob
  queue_as :v4_global_race_update

  def perform(status, message, race)
    ws_msg = Api::V4::WebsocketMessage.new(
      status,
      message: message,
      race:    Api::V4::RaceBlueprint.render_as_hash(race, view: race.type)
    )
    ActionCable.server.broadcast(
      'v4:global_race_channel',
      race: Api::V4::WebsocketMessageBlueprint.render_as_hash(ws_msg)
    )
  end
end
