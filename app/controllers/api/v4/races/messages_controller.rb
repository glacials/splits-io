class Api::V4::Races::MessagesController < Api::V4::RacesController
  before_action :set_user, only: %i[create]
  before_action :validate_user, only: %i[create]
  before_action :set_race, only: %i[index create]
  before_action :set_messages, only: %i[index]

  def index
    render status: :ok, json: Api::V4::ChatMessageBlueprint.render(paginate(@messages), root: :chat_messages)
  end

  def create
    chat_message = @race.chat_messages.new(message_params.merge(
      user:         current_user,
      from_entrant: @race.entry_for_user(current_user).present?
    ))
    if chat_message.save
      render status: :created, json: Api::V4::ChatMessageBlueprint.render(chat_message, root: :chat_message)
      Api::V4::MessageBroadcastJob.perform_later(@race, chat_message)
    else
      render status: :bad_request, json: {
        status: 400,
        error:  chat_message.errors.full_messages.to_sentence
      }
    end
  end

  private

  def message_params
    params.permit(:body)
  end

  def set_messages
    @messages = @race.chat_messages.order(created_at: :desc)
  end
end
