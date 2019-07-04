class Api::V4::GlobalRaceUpdateJob < ApplicationJob
  queue_as :v4_races

  def perform(race, status, message)
    ws_msg = Api::V4::WebsocketMessage.new(
      status,
      message:  message,
      race: Api::V4::RaceBlueprint.render_as_hash(race)
    )
    ActionCable.server.broadcast(
      'v4:global_race_channel',
      ws_msg.to_h
    )
  end
end
