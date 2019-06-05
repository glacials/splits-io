class Api::V4::Races::Entrants::ApplicationController < Api::V4::ApplicationController
  before_action :set_user
  before_action :set_raceable
  before_action :set_entrant, only: %i[update destroy]

  def show
    entrant = @raceable.entrants.find_by(user: current_user)
    if entrant
      render status: :ok, json: Api::V4::EntrantBlueprint.render(entrant, root: :entrant)
    else
      render status: :no_content
    end
  end

  def create
    entrant = @raceable.entrants.new(user: current_user)
    if entrant.save
      render status: :created, json: Api::V4::EntrantBlueprint.render(entrant, root: :entrant)
    else
      render status: :bad_request, json: {
        status: :bad_request,
        error:  entrant.errors.full_messages.to_sentence
      }
    end
  end

  def update
    if @entrant.update(entrant_params)
      render status: :ok, json: Api::V4::EntrantBlueprint.render(@entrant, root: :entrant)
    else
      render status: :bad_request, json: {
        status: :bad_request,
        error:  @entrant.errors.full_messages.to_sentence
      }
    end
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
    if request.headers['Authorization'].present?
      doorkeeper_authorize!(:manage_race)
      current_user = User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    head :unauthorized if current_user.nil?
  end

  def set_raceable(klass)
    @raceable = klass.where(
      'LEFT(id::text, ?) = ?',
      params[:race].length,
      params[:race]
    ).order(created_at: :asc).first
    raise ActiveRecord::RecordNotFound if @raceable.nil?
    head :unauthorized if @raceable.secret_visibility? && !@raceable.joinable?(user: current_user, token: params[:join_token])
  rescue ActiveRecord::RecordNotFound
    render not_found(klass.type)
  end

  def set_entrant
    @entrant = Entrant.find_by(user: current_user, raceable: @raceable)
    raise ActiveRecord::RecordNotFound if @entrant.nil?
  rescue ActiveRecord::RecordNotFound
    render not_found(:entrant)
  end

  def entrant_params
    params.each do |k, v|
      if k[-3, -1] == '_at' && v == 'now'
        params[k] = Time.now.utc
      end
    end
    params.require(:entrant).permit(:readied_at, :finished_at, :forfeited_at)
  end
end
