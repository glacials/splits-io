class Api::V4::Races::Entrants::ApplicationController < Api::V4::ApplicationController
  before_action :set_time, only: %i[update]
  before_action :set_user
  before_action :set_raceable
  before_action :set_entrant, only: %i[show update destroy]

  def show
    render status: :ok, json: Api::V4::EntrantBlueprint.render(@entrant, root: :entrant)
  end

  def create
    entrant = @raceable.entrants.new(user: current_user)
    if entrant.save
      render status: :created, json: Api::V4::EntrantBlueprint.render(entrant, root: :entrant)
      Api::V4::RaceBroadcastJob.perform_later(@raceable, 'race_entrants_updated', 'A new entrant has joined')
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
      updated = @entrant.saved_changes.keys.reject { |k| k == 'updated_at' }.map { |k| k[0...-3] }.join('and')
      Api::V4::RaceBroadcastJob.perform_later(@raceable, 'race_entrants_updated', "An entrant has #{updated}")
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
    @time = Time.now.utc
  end

  def set_entrant
    @entrant = Entrant.find_by!(user: current_user, raceable: @raceable)
  rescue ActiveRecord::RecordNotFound
    render not_found(:entrant)
  end

  def entrant_params
    params.each do |k, v|
      params[k] = @time if k[-3, -1] == '_at' && v == 'now'
    end
    params.require(:entrant).permit(:readied_at, :finished_at, :forfeited_at)
  end
end
