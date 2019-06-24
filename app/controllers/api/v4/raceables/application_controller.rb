class Api::V4::Raceables::ApplicationController < Api::V4::ApplicationController
  before_action :set_raceable, only: %i[show update]
  before_action :set_raceables, only: %i[index]
  before_action :set_user, only: %i[create update]
  before_action :check_user, only: %i[create]
  before_action :check_permission, only: %i[show]
  before_action :check_owner, only: %i[update]

  # Define all methods otherwise rubocop complains above
  def index
  end

  def create(raceable)
    raceable.owner = current_user
    if raceable.save
      render status: :created, json: Api::V4::RaceBlueprint.render(
        raceable,
        root:       raceable.type,
        view:       raceable.type,
        join_token: true
      )
      Api::V4::GlobalRaceableUpdateJob.perform_later(raceable, 'raceable_created', "A new #{raceable.type} has been created")
    else
      render status: :bad_request, json: {
        status: 400,
        error:  raceable.errors.full_messages.to_sentence
      }
    end
  end

  def show
  end

  def update
  end

  private

  def set_raceables(klass) # rubocop:disable Naming/AccessorMethodName
    @raceables = klass.active
  end

  def check_user
    return if params[:visibility].nil? || params[:visibility] == 'public' || current_user.patron?(tier: 2)

    render status: :forbidden, json: {
      status: 403,
      error:  'Must be a tier 3 patreon to make non-public races'
    }
  end

  def check_permission
    return unless @raceable.secret_visibility? && @raceable.joinable?(token: params[:join_token])

    render status: :unauthorized, json: {
      status: 403,
      error:  'Invalid join token for secret race lookup.'
    }
  end

  def check_owner
    return if @raceable.belongs_to?(current_user)

    head :unauthorized
  end
end
