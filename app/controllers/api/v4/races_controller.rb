class Api::V4::RacesController < Api::V4::ApplicationController
  before_action :set_user, only: %i[create show update]
  before_action :validate_user, only: %i[create]
  before_action :set_race, only: %i[show update]
  before_action :set_races, only: %i[index]
  before_action :check_permission, only: %i[show]
  before_action :check_owner, only: %i[update]

  def index
    render json: Api::V4::RaceBlueprint.render(@races, root: :races)
  end

  def create
    @race = Race.create(race_params.merge(owner: current_user))
    if @race.persisted?
      Api::V4::GlobalRaceUpdateJob.perform_later(@race, 'race_created', 'A new race has been created')
      render status: :created, json: Api::V4::RaceBlueprint.render(@race, root: :race, join_token: true)
    else
      render status: :bad_request, json: {
        status: 400,
        error:  @race.errors.full_messages.to_sentence
      }
    end
  end

  def show
    render json: Api::V4::RaceBlueprint.render(@race, root: :race, chat: true)
  end

  def update
    if params[:race][:attachments].present?
      @race.attachments.attach(params[:race][:attachments])
      Api::V4::RaceBroadcastJob.perform_later(@race, 'new_attachment', 'The race has a new attachment')
    end

    if @race.update(race_params)
      updated = @race.saved_changes.keys.reject { |k| k == 'updated_at' }.to_sentence
      Api::V4::RaceBroadcastJob.perform_later(@race, 'race_updated', "The race's #{updated} has changed") if updated.present?
      render status: :ok, json: Api::V4::RaceBlueprint.render(@race, root: :race, chat: true)
    else
      render status: :bad_request, json: {
        status: 400,
        error:  @race.errors.full_messages.to_sentence
      }
    end
  rescue ActionController::ParameterMissing
    render status: :bad_request, json: {
      status: 400,
      error:  'Missing parameter: "race"'
    }
  end

  private

  def race_params
    params.require(:race).permit(:visibility, :notes, :category_id, :game_id)
  end

  def set_race
    super(param: :id)
  end

  def set_races
    if params[:historic] == '1'
      @races = paginate(Race.finished.not_secret_visibility.order(started_at: :desc))
    else
      @races = paginate(Race.active.not_secret_visibility)
    end

    @races.includes(:category, :user, game: :srdc, entries: {runner: [:google, :twitch], creator: [:google, :twitch]})
  end

  def check_permission
    return unless @race.secret_visibility? && !@race.joinable?(token: params[:join_token], user: current_user)

    render status: :unauthorized, json: {
      status: 403,
      error:  'Invalid join token for secret race lookup.'
    }
  end

  def check_owner
    return if @race.belongs_to?(current_user)

    render :unauthorized, json: {
      status: 401,
      error:  "User must own race to perform this action"
    }
  end
end
