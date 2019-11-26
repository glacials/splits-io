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

  def create # rubocop:todo Metrics/AbcSize Metrics/CyclomaticComplexity Metrics/MethodLength
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
        error:  entry.errors.full_messages.to_sentence,
      }
      return
    end
  rescue ActionController::ParameterMissing
    render status: :bad_request, json: {
      status: 400,
      error:  'Specifying at least one entry param is required, e.g. {"entry": {"readied_at": "now"}}',
    }
  end

  def update
    unless @entry.update(entry_params)
      render status: :bad_request, json: {
        status: 400,
        error:  @entry.errors.full_messages.to_sentence,
      }
      return
    end
    render status: :ok, json: Api::V4::EntryBlueprint.render(@entry, root: :entry)
    updated = @entry.saved_changes.keys.reject { |k| k == 'updated_at' }.to_sentence

    if @entry.saved_changes.keys.include?('finished_at')
      # If this was the last split
      if @entry.finished_at && @entry.run&.segments&.where(Run.duration_type(Run::REAL) => nil)&.count == 1
        @entry.run.split(
          more:            false,
          realtime_end_ms: (@entry.finished_at - @entry.race.started_at) * 1000,
          gametime_end_ms: nil,
        )
        run_history = @entry.run.histories.order(attempt_number: :asc).last
        run_history.update(
          realtime_duration_ms: (@entry.finished_at - @entry.race.started_at) * 1000,
          gametime_duration_ms: nil,
          ended_at:             run_history.started_at + (@entry.finished_at - @entry.race.started_at),
        )
      end
      if @entry.finished_at.nil? && @entry.run&.segments&.where(Run.duration_type(Run::REAL) => nil)&.count&.zero?
        @entry.run.segments.order(segment_number: :asc).last.update(
          realtime_end_ms:      nil,
          realtime_duration_ms: nil,
          realtime_gold:        false,
          gametime_end_ms:      nil,
          gametime_duration_ms: nil,
          gametime_gold:        false,
        )
        @entry.run.update(
          realtime_duration_ms: nil,
          gametime_duration_ms: nil,
        )
      end
    end

    Api::V4::RaceBroadcastJob.perform_later(
      @race,
      'race_entries_updated',
      "An entry's #{updated} has changed",
    )
  end

  def destroy
    if @entry.destroy
      render status: :ok, json: {status: 200}
      Api::V4::RaceBroadcastJob.perform_later(@race, 'race_entries_updated', 'A user has left the race')
      Api::V4::GlobalRaceUpdateJob.perform_later(@race, 'race_entries_updated', 'A user has left a race')
    else
      render status: :conflict, json: {
        status: 409,
        error:  @entry.errors.full_messages.to_sentence,
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
      error:  'Must be invited to this race',
    }
  end

  def set_entry(param: :id) # rubocop:disable Naming/AccessorMethodName
    @entry = @race.entries.find(params[param])
    return if @entry.creator == current_user

    render status: :forbidden, json: {
      status: 403,
      error:  'Entry does not belong to current user',
    }
  rescue ActiveRecord::RecordNotFound
    render not_found(:entry)
  end

  def massage_params
    params[:entry][:run_id] = params[:entry][:run_id].to_i(36) if params.dig(:entry, :run_id).present?
    params[:entry]&.each do |k, v|
      params[:entry][k] = @now if v == 'now'
    end
  end

  def entry_params
    params[:entry].present? ? params.require(:entry).permit(:readied_at, :finished_at, :forfeited_at, :run_id) : {}
  end

  def update_race
    return unless response.status == 200

    @race.maybe_start!
    @race.maybe_end!
  end
end
