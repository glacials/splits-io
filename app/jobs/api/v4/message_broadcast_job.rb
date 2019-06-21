class Api::V4::MessageBroadcastJob < ApplicationJob
  queue_as :v4_message_broadcast

  def perform(raceable, chat_message)
    msg = {
      message:      'A new message has been created',
      chat_message: Api::V4::ChatMessageBlueprint.render_as_hash(chat_message)
    }
    onsite_msg = {
      message:   'New html',
      chat_html: ApplicationController.render(partial: 'chat_messages/show', locals: {chat_message: chat_message})
    }
    ws_msg = Api::V4::WebsocketMessage.new('new_message', msg)
    ws_onsite_msg = Api::V4::WebsocketMessage.new('new_message:html', onsite_msg)

    Api::V4::RaceableChannel.broadcast_to(raceable, ws_msg.to_h)
    ActionCable.server.broadcast("api:v4:raceable:#{raceable.to_gid_param}:onsite", ws_onsite_msg.to_h)
  end
end
