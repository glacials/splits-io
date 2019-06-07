class Api::V4::Races::Messages::ApplicationController < Api::V4::ApplicationController
  before_action :set_user, only: %i[create]
  before_action :set_raceable, only: %i[create]

  def index
    render status: :ok, json: Api::V4::ChatMessageBlueprint.render(@messages)
  end

  def create
    chat_message = @raceable.chat_messages.new(
      body: params[:body],
      user: current_user,
      entrant: @raceable.entrant_for_user(current_user).present?,
    )
    if chat_message.save
      render status: :ok, json: Api::V4::ChatMessageBlueprint.render(chat_message)
      Api::V4::MessageBroadcastJob.perform_later(@raceable, chat_message)
    else
      render status: :bad_request, json: {
        status: :bad_request,
        error:  chat_message.errors.full_messages.to_sentence
      }
    end
  end

  private

  def set_messages
    @messages = @raceable.chat_messages
  end
end
