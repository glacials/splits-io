class Api::V4::RaceableChannel < Api::V4::ApplicationChannel
  def subscribed
    @race = Raceable.race_from_type(params[:raceable_type]).find_by(id: params[:raceable_id])
    if @race.nil?
      transmit_user('raceable_not_found', "No race found with id: #{params[:raceable_id]}")
      reject
      return
    end

    if @race.secret_visibility? && !@race.joinable?(user: current_user, token: params[:join_token])
      transmit_user('raceable_invalid_join_token', 'The join token provided is not valid for this race')
      reject
    else
      stream_for(@race)
      stream_from("api:v4:raceable:#{@race.to_gid_param}:onsite") if onsite
      return unless params[:state] == '1'

      ws_msg = Api::V4::WebsocketMessage.new(
        'raceable_state',
        message: 'Raceable state',
        race:    Api::V4::RaceBlueprint.render_as_hash(@race, view: @race.type, chat: true)
      )

      transmit(ws_msg.to_h)
    end
  rescue StandardError => e
    Rails.logger.error([e.message, *e.backtrace].join($RS))
    Rollbar.error(e, 'Uncaught error for Api::V4::RaceableChannel#subscribed')
    transmit_user('fatal_error', 'A fatal error occurred while processing your subscription request')
  end

  def unsubscribed
    stop_all_streams
  end
end
