class Api::V1::ChatChannel < ApplicationCable::Channel
  def subscribed
    @chat_room = ChatRoom.find_by(id: params[:chat_room_id])
    reject if @chat_room.nil?
    return unless params[:state] == '1'

    # send messages
  end

  def unsubscribed
    stop_all_streams
  end

  def send_message(data)
    return if current_user.nil?

    update_chat_room_instance
    if @chat_room.locked?
      transmit_user('chat_room_locked_error', 'This chat room has been locked')
    end
  end

  private

  def update_chat_room_instance
    # Instance variables do not update automatically, so we call this function before anything that needs
    # to check the state of the chat room variable to make sure it isn't stale
    @chat_room.reload
  end
end
