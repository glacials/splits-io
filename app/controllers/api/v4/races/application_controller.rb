class Api::V4::Races::ApplicationController < Api::V4::ApplicationController
  before_action :set_raceable, only: %i[show update]
  before_action :set_raceables, only: %i[index]
  before_action :set_user, only: %i[create update]
  before_action :check_user, only: %i[create]
  before_action :check_permission, only: %i[update]

  # Define all methods otherwise rubocop complains above
  def index
  end

  def create
  end

  def show
  end

  def update
  end

  private

  def set_raceable(klass)
    @raceable = klass.find(params[:raceable])
  end

  def set_raceables(klass) # rubocop:disable Naming/AccessorMethodName
    @raceables = klass.active
  end

  def check_user
    if current_user.nil?
      head :unauthorized if current_user.nil?
      return
    end
    return if params[:visibility].nil? || params[:visibility] == 'public' || current_user.patron?(tier: 3)

    render status: :forbidden, json: {
      status: :forbidden,
      error:  'Must be a tier 3 patreon to make non-public races'
    }
  end

  def check_permission
    return if @raceable.belongs_to?(current_user)

    head :unauthorized
  end
end
