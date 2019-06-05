class Api::V4::Races::ApplicationController < Api::V4::ApplicationController
  before_action :set_races, only: %i[index]
  before_action :set_user, only: %i[create show update]
  before_action :check_user, only: %i[create]
  before_action :set_race, only: %i[show update]
  before_action :check_permission, only: %i[update]

  private

  def set_races(klass)
    @races = klass.active
  end

  def set_user
    doorkeeper_authorize!(:manage_race) if headers['Authorization'].present?
    self.current_user = User.find_by(id: doorkeeper_token.try(:resource_owner_id))
  end

  def check_user
    head :unauthorized if current_user.nil?
  end

  def set_race(klass)
    @race = klass.where(
      'LEFT(id::text, ?) = ?',
      params[:race].length,
      params[:race]
    ).order(created_at: :asc).first
    raise ActiveRecord::RecordNotFound if @race.nil?
    return unless @race.secret_visibility? && !@race.joinable?(user: current_user, token: params[:join_token])

    head :unauthorized
  rescue ActiveRecord::RecordNotFound
    render not_found(klass.type)
  end

  def check_permission
    return if @race.belongs_to?(current_user)

    render :unauthorized
  end
end
