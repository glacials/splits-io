class Api::V4::Raceables::Messages::ApplicationController < Api::V4::ApplicationController
  before_action :set_user, only: %i[create]
  before_action :set_raceable, only: %i[index create]
  before_action :set_messages, only: %i[index]

  def index
    paginated_messages = paginate(@messages)
    render status: :ok, json: Api::V4::ChatMessageBlueprint.render(paginated_messages, root: :chat_messages)
  end

  def create
    chat_message = @raceable.chat_messages.new(
      body:         params[:body],
      user:         current_user,
      from_entrant: @raceable.entry_for_user(current_user).present?
    )
    if chat_message.save
      render status: :created, json: Api::V4::ChatMessageBlueprint.render(chat_message, root: :chat_message)
      Api::V4::MessageBroadcastJob.perform_later(@raceable, chat_message)
    else
      render status: :bad_request, json: {
        status: 400,
        error:  chat_message.errors.full_messages.to_sentence
      }
    end
  end

  private

  def set_messages
    @messages = @raceable.chat_messages.order(created_at: :desc)
  end
end
