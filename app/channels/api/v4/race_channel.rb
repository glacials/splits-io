class Api::V4::RaceChannel < Api::V4::ApplicationChannel
  def subscribed
    @race = Race.find_by(id: params[:race_id])
    if @race.nil?
      transmit_user('race_not_found', "No race found with id: #{params[:race_id]}")
      reject
      return
    end

    if @race.secret_visibility? && !@race.joinable?(user: current_user, token: params[:join_token])
      transmit_user('race_invalid_join_token', 'The join token provided is not valid for this race')
      reject
    else
      stream_for(@race)
      stream_from("api:v4:race:#{@race.to_gid_param}:onsite") if onsite
      return unless params[:state] == '1'

      ws_msg = Api::V4::WebsocketMessage.new(
        'race_state',
        message: 'Race state',
        race:    Api::V4::RaceBlueprint.render_as_hash(@race, view: @race.type, chat: true)
      )

      transmit(ws_msg.to_h)
    end
  rescue StandardError => e
    Rails.logger.error([e.message, *e.backtrace].join($RS))
    Rollbar.error(e, 'Uncaught error for Api::V4::RaceChannel#subscribed')
    transmit_user('fatal_error', 'A fatal error occurred while processing your subscription request')
  end

  def unsubscribed
    stop_all_streams
  end
end
