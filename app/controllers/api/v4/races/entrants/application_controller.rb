class Api::V4::Races::Entrants::ApplicationController < Api::V4::ApplicationController
  before_action :set_user
  before_action :check_user
  before_action :set_race
  before_action :set_entrant, only: %i[update destroy]

  def create
    entrant = @race.entrants.new(user: current_user)
    if entrant.save
      render status: :created, json: Api::V4::EntrantBlueprint.render(entrant)
    else
      render status: :bad_request, json: {
        status: :bad_request,
        error:  entrant.errors.full_messages.to_sentence
      }
    end
  end

  def update
    # TODO: all the updating (ready, unready, done, forfeit, rejoin)
  end

  def destroy
    if @entrant.destroy
      head :reset_content
    else
      render status: :conflict, json: {
        status: :conflict,
        error:  @entrant.errors.full_messages.to_sentence
      }
    end
  end

  private

  def set_user
    doorkeeper_authorize!(:manage_race) if headers['Authorization'].present?
    self.current_user = User.find_by(id: doorkeeper_token.try(:resource_owner_id))
  end

  def check_user
    head :unauthorized if current_user.nil?
  end

  def set_race(klass)
    @race = klass.where(
      'LEFT(id::text, ?) = ?',
      params[:race].length,
      params[:race]
    ).order(created_at: :asc).first
    raise ActiveRecord::RecordNotFound if @race.nil?
    return unless @race.secret_visibility? && !@race.joinable?(user: current_user, token: params[:join_token])

    head :unauthorized
  rescue ActiveRecord::RecordNotFound
    render not_found(klass.type)
  end

  def set_entrant
    @entrant = Entrant.find(params[:entrant])
    return if @entrant.user == current_user

    head :forbidden
  rescue ActiveRecord::RecordNotFound
    render not_found(:entrant)
  end
end
