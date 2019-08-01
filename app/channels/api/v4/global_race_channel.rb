class Api::V4::GlobalRaceChannel < Api::V4::ApplicationChannel
  def subscribed
    stream_from('v4:global_race_channel')
    return unless params[:state] == '1'

    ws_msg = Api::V4::WebsocketMessage.new(
      'global_state',
      message:     'Global race state',
      races:       Api::V4::RaceBlueprint.render_as_hash(Race.active.not_secret_visibility),
    )
    transmit(ws_msg.to_h)
  rescue StandardError => e
    Rails.logger.error([e.message, *e.backtrace].join($RS))
    Rollbar.error(e, 'Uncaught error for Api::V4::GlobalRaceChannel#subscribed')
    transmit_user('fatal_error', 'A fatal error occurred while processing your subscription request')
  end

  def unsubscribed
    stop_all_streams
  end
end
