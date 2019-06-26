class Api::V4::Raceables::Entries::ApplicationController < Api::V4::ApplicationController
  before_action :set_time, only: %i[update]
  before_action :set_user
  before_action :validate_user
  before_action :set_raceable
  before_action :check_permission, only: %i[create]
  before_action :massage_params
  before_action :set_entry, only: %i[show update destroy]
  after_action  :update_race, only: %i[update]

  def show
    render status: :ok, json: Api::V4::EntryBlueprint.render(@entry, root: :entry)
  end

  def create
    entry = @raceable.entries.new(entry_params)
    entry.user = current_user
    if entry.save
      render status: :created, json: Api::V4::EntryBlueprint.render(entry, root: :entry)
      Api::V4::RaceableBroadcastJob.perform_later(@raceable, 'raceable_entries_updated', 'A user has joined the race')
      Api::V4::GlobalRaceableUpdateJob.perform_later(@raceable, 'raceable_entries_updated', 'A user has joined a race')
    else
      render status: :bad_request, json: {
        status: 400,
        error:  entry.errors.full_messages.to_sentence
      }
    end
  rescue ActionController::ParameterMissing
    render status: :bad_request, json: {
      status: 400,
      error:  'Specifying at least one entry param is required'
    }
  end

  def update
    if @entry.update(entry_params)
      render status: :ok, json: Api::V4::EntryBlueprint.render(@entry, root: :entry)
      updated = @entry.saved_changes.keys.reject { |k| k == 'updated_at' }.to_sentence
      Api::V4::RaceableBroadcastJob.perform_later(
        @raceable,
        'raceable_entries_updated',
        "An entry's #{updated} has changed"
      )
    else
      render status: :bad_request, json: {
        status: 400,
        error:  @entry.errors.full_messages.to_sentence
      }
    end
  rescue ActionController::ParameterMissing
    render status: :bad_request, json: {
      status: 400,
      error:  'Missing parameter: "entry"'
    }
  end

  def destroy
    if @entry.destroy
      head :reset_content
      Api::V4::RaceableBroadcastJob.perform_later(@raceable, 'raceable_entries_updated', 'A user has left the race')
      Api::V4::GlobalRaceableUpdateJob.perform_later(@raceable, 'raceable_entrants_updated', 'An user has left a race')
    else
      render status: :conflict, json: {
        status: 409,
        error:  @entry.errors.full_messages.to_sentence
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
      status: 403,
      error:  'Must be invited to this race'
    }
  end

  def set_entry
    @entry = Entry.find_by!(user: current_user, raceable: @raceable)
  rescue ActiveRecord::RecordNotFound
    render not_found(:entry)
  end

  def massage_params
    params[:entry][:run_id] = Run.find36(params[:entry][:run_id]).id if params[:entry].try(:[], :run_id).present?
  end

  def entry_params
    params.select { |k, _| k[-3, -1] == '_at' && v == 'now' }.each do |k, _|
      params[k] = @now
    end
    params.permit(:join_token, entry: %i[readied_at finished_at forfeited_at run_id]).fetch(:entry, {})
  end

  def update_race
    return unless response.status == 200

    @raceable.maybe_start!
    @raceable.maybe_end!
  end
end
