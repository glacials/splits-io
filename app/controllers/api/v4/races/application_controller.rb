class Api::V4::Races::ApplicationController < Api::V4::ApplicationController
  before_action :set_raceables, only: %i[index]
  before_action :set_user, only: %i[create update]
  before_action :check_user, only: %i[create]
  before_action :set_raceable, only: %i[show update]
  before_action :check_permission, only: %i[update]

  private

  def set_raceables(klass)
    @raceables = klass.active
  end

  def check_user
    head :unauthorized if current_user.nil?
  end

  def check_permission
    return if @raceable.belongs_to?(current_user)

    head :unauthorized
  end
end
