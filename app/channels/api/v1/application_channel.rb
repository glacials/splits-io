class Api::V1::ApplicationChannel < ApplicationCable::Channel
  private

  def transmit_user(type, msg, **extra)
    ws_msg = Api::V1::WebsocketMessage.new(type, message: msg, **extra)
    transmit(Api::V1::WebsocketMessageBlueprint.render_as_hash(ws_msg))
  end

  def check_user
    invalid = current_user.nil?
    return unless invalid

    transmit_user('user_absent_error', 'Must be authenticated to perform this action (you are anonymous)')
    invalid
  end

  def check_oauth
    invalid = oauth_token.expired? || !oauth_token.includes_scope?(:manage_race)
    return unless invalid

    transmit_user('oauth_expired_error', 'Your oauth token is no longer valid, you will be demoted to anonymous mode')
    invalid
  end
end
