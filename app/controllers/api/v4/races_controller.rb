class Api::V4::RacesController < Api::V4::ApplicationController
  before_action :set_user, only: %i[create show update]
  before_action :validate_user, only: %i[create]
  before_action :set_race, only: %i[show update]
  before_action :set_races, only: %i[index]
  before_action :check_patron, only: %i[create]
  before_action :check_permission, only: %i[show]
  before_action :check_owner, only: %i[update]

  def index
    render json: Api::V4::RaceBlueprint.render(@races, root: :races)
  end

  def create
    @race = Race.create(race_params.merge(owner: current_user))
    if @race.persisted?
      render status: :created, json: Api::V4::RaceBlueprint.render(@race, root: :race, join_token: true)
      Api::V4::GlobalRaceUpdateJob.perform_later(@race, 'race_created', "A new race has been created")
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

  # define method for rubocop
  def update
  end

  private

  def race_params
    params.permit(:visibility, :notes, :category_id, :game_id)
  end

  def set_races # rubocop:disable Naming/AccessorMethodName
    @races = Race.active.not_secret_visibility
  end

  def check_patron
    return if params[:visibility].nil? || params[:visibility] == 'public' || current_user.patron?(tier: 2)

    render status: :forbidden, json: {
      status: 403,
      error:  'Must be a tier 3 patreon to make non-public races'
    }
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

    head :unauthorized
  end
end
