class Api::V4::Races::Entries::SplitsController < Api::V4::Races::EntriesController
  before_action :set_time, only: %i[create]
  before_action :set_user
  before_action :validate_user
  before_action :set_race
  before_action :set_entry
  before_action :set_run
  before_action :check_permission

  def create
    @run.split(
      more: params[:more] == '1',
      realtime_end_ms: split_params[:realtime_end_ms],
      gametime_end_ms: split_params[:gametime_end_ms],
    )

    # If this was the final split
    if @run.completed?(Run::REAL)
      run_history = @run.histories.order(attempt_number: :asc).last
      run_history.update(split_params.merge(ended_at: run_history.started_at + (split_params[:realtime_end_ms] / 1000)))

      # If this was a race run
      @run.entry&.update(finished_at: run_history.ended_at)
    end

    Api::V4::RaceBroadcastJob.perform_later(@race, 'race_entries_updated', 'A user has split')

    render json: Api::V4::RunBlueprint.render(@run)
  end

  private

  def set_time
    @now = Time.now.utc
  end

  def split_params
    params.require(:split).permit(
      :realtime_end_ms,
      :gametime_end_ms,
      :realtime_gold,
      :gametime_gold,
      :realtime_skipped,
      :gametime_skipped,
    )
  end

  def set_entry
    super(param: :entry_id)
  end

  def set_run
    @run = @entry.run

    @run ||= @entry.create_run(
      user:                 current_user,
      category:             @race.category,
      game:                 @race.game,
      program:              'exchange',
      attempts:             0,
      s3_filename:          SecureRandom.uuid,
      realtime_duration_ms: nil,
      gametime_duration_ms: nil,
      parsed_at:            @now,
      default_timing:       Run::REAL,
    )

    return if @run.histories.where(started_at: @entry.race.started_at).any?

    @run.histories.create(
      started_at:        @entry.race.started_at,
      attempt_number:    @run.histories.order(attempt_number: :asc).last,
      pause_duration_ms: 0,
    )
  end
end
