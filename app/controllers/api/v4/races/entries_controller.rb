class Api::V4::Races::EntriesController < Api::V4::ApplicationController
  before_action :set_time, only: %i[update]
  before_action :set_user
  before_action :validate_user
  before_action :set_race
  before_action :check_permission, only: %i[create]
  before_action :massage_params
  before_action :set_entry, only: %i[show update destroy]
  after_action  :update_race, only: %i[update]

  def show
    render status: :ok, json: Api::V4::EntryBlueprint.render(@entry, root: :entry)
  end

  def create
    entry = @race.entries.new(entry_params)
    entry.runner  = current_user # if this is a ghost, the validator will correct the runner
    entry.creator = current_user
    if entry.save
      render status: :created, json: Api::V4::EntryBlueprint.render(entry, root: :entry)
      Api::V4::RaceBroadcastJob.perform_later(@race, 'race_entries_updated', 'A user has joined the race')
      Api::V4::GlobalRaceUpdateJob.perform_later(@race, 'race_entries_updated', 'A user has joined a race')
    else
      render status: :bad_request, json: {
        status: 400,
        error:  entry.errors.full_messages.to_sentence
      }
    end
  rescue ActionController::ParameterMissing
    render status: :bad_request, json: {
      status: 400,
      error:  'Specifying at least one entry param is required, e.g. {"entry": {"readied_at": "now"}}'
    }
  end

  def update
    if @entry.update(entry_params)
      render status: :ok, json: Api::V4::EntryBlueprint.render(@entry, root: :entry)
      updated = @entry.saved_changes.keys.reject { |k| k == 'updated_at' }.to_sentence
      Api::V4::RaceBroadcastJob.perform_later(
        @race,
        'race_entries_updated',
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
      render status: :ok, json: {status: 200}
      Api::V4::RaceBroadcastJob.perform_later(@race, 'race_entries_updated', 'A user has left the race')
      Api::V4::GlobalRaceUpdateJob.perform_later(@race, 'race_entries_updated', 'An user has left a race')
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
    return if @race.joinable?(token: params[:join_token], user: current_user)

    render status: :forbidden, json: {
      status: 403,
      error:  'Must be invited to this race'
    }
  end

  def set_entry
    @entry = @race.entries.find(params[:id])
    return if @entry.creator == current_user

    render status: :forbidden, json: {
      status: 403,
      error:  'Entry does not belong to current user'
    }
  rescue ActiveRecord::RecordNotFound
    render not_found(:entry)
  end

  def massage_params
    params[:entry][:run_id] = params[:entry][:run_id].to_i(36) if params[:entry].try(:[], :run_id).present?
  end

  def entry_params
    params.select { |k, _| k[-3, -1] == '_at' && v == 'now' }.each do |k, _|
      params[k] = @now
    end
    params[:entry].present? ? params.require(:entry).permit(:readied_at, :finished_at, :forfeited_at, :run_id) : {}
  end

  def update_race
    return unless response.status == 200

    @race.maybe_start!
    @race.maybe_end!
  end
end
