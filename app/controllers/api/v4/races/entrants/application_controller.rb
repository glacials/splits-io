class Api::V4::Races::Entrants::ApplicationController < Api::V4::ApplicationController
  before_action :set_time, only: %i[update]
  before_action :set_user
  before_action :set_raceable
  before_action :check_permission, only: %i[create]
  before_action :massage_params
  before_action :set_entrant, only: %i[show update destroy]
  after_action  :update_race, only: %i[update]

  def show
    render status: :ok, json: Api::V4::EntrantBlueprint.render(@entrant, root: :entrant)
  end

  def create
    entrant = @raceable.entrants.new(entrant_params)
    entrant.user = current_user
    if entrant.save
      render status: :created, json: Api::V4::EntrantBlueprint.render(entrant, root: :entrant)
      Api::V4::RaceBroadcastJob.perform_later(@raceable, 'race_entrants_updated', 'A new entrant has joined')
    else
      render status: :bad_request, json: {
        status: :bad_request,
        error:  entrant.errors.full_messages.to_sentence
      }
    end
  rescue ActionController::ParameterMissing
    render status: :bad_request, json: {
      status: :bad_request,
      error: 'Specifying at least one entrant param is required',
    }
  end

  def update
    if @entrant.update(entrant_params)
      render status: :ok, json: Api::V4::EntrantBlueprint.render(@entrant, root: :entrant)
      updated = @entrant.saved_changes.keys.reject { |k| k == 'updated_at' }.to_sentence
      Api::V4::RaceBroadcastJob.perform_later(
        @raceable,
        'race_entrants_updated',
        "An entrant has changed their #{updated}"
      )
    else
      render status: :bad_request, json: {
        status: :bad_request,
        error:  @entrant.errors.full_messages.to_sentence
      }
    end
  rescue ActionController::ParameterMissing
    render status: :bad_request, json: {
      status: :bad_request,
      error:  'Missing parameter: "entrant"'
    }
  end

  def destroy
    if @entrant.destroy
      head :reset_content
      Api::V4::RaceBroadcastJob.perform_later(@raceable, 'race_entrants_updated', 'An entrant has left the race')
    else
      render status: :conflict, json: {
        status: :conflict,
        error:  @entrant.errors.full_messages.to_sentence
      }
    end
  end

  private

  def set_time
    @now = Time.now.utc
  end

  def check_permission
    return if @raceable.joinable?(token: params[:join_token], user: current_user)

    render status: :forbidden, json: {
      status: :forbidden,
      error:  'Must be invited to this race'
    }
  end

  def set_entrant
    @entrant = Entrant.find_by!(user: current_user, raceable: @raceable)
  rescue ActiveRecord::RecordNotFound
    render not_found(:entrant)
  end

  def massage_params
    params[:entrant][:run_id] = Run.find36(params[:entrant][:run_id]).id if params[:entrant].try(:[], :run_id).present?
  end

  def entrant_params
    params.select { |k, _| k[-3, -1] == '_at' && v == 'now' }.each do |k, v|
      params[k] = @now
    end
    params.permit(entrant: [:readied_at, :finished_at, :forfeited_at, :run_id]).fetch(:entrant, {})
  end

  def update_race
    return unless response.status == 200

    @raceable.maybe_start!
    @raceable.maybe_end!
  end
end
