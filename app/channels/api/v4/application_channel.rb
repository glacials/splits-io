class Api::V4::ApplicationChannel < ApplicationCable::Channel
  def transmit_user(type, msg, **extra)
    ws_msg = Api::V4::WebsocketMessage.new(type, message: msg, **extra)
    transmit(ws_msg.to_h)
  end
end
