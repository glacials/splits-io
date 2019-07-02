class Api::V4::Raceables::ApplicationController < Api::V4::ApplicationController
  before_action :set_user, only: %i[create show update]
  before_action :validate_user, only: %i[create]
  before_action :set_raceable, only: %i[show update]
  before_action :set_raceables, only: %i[index]
  before_action :check_patron, only: %i[create]
  before_action :check_permission, only: %i[show]
  before_action :check_owner, only: %i[update]

  def index(raceables, klass)
    render json: Api::V4::RaceBlueprint.render(
      raceables,
      view: klass.type,
      root: klass.type.to_s.pluralize
    )
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

  def show(raceable)
    render json: Api::V4::RaceBlueprint.render(
      raceable,
      root: raceable.type,
      view: raceable.type,
      chat: true
    )
  end

  # define method for rubocop
  def update
  end

  private

  def set_raceables(klass) # rubocop:disable Naming/AccessorMethodName
    @raceables = klass.active.not_secret_visibility
  end

  def check_patron
    return if params[:visibility].nil? || params[:visibility] == 'public' || current_user.patron?(tier: 2)

    render status: :forbidden, json: {
      status: 403,
      error:  'Must be a tier 3 patreon to make non-public races'
    }
  end

  def check_permission
    return unless @raceable.secret_visibility? && !@raceable.joinable?(token: params[:join_token], user: current_user)

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
