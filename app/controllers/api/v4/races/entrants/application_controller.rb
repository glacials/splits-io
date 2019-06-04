class Api::V4::Races::Entrants::ApplicationController < Api::V4::ApplicationController
  before_action :set_time
  before_action :set_user
  before_action :set_raceable
  before_action :set_entrant, only: %i[update destroy]
  before_action :set_column, only: %i[update]

  def create
    entrant = @raceable.entrants.new(user: current_user)
    if entrant.save
      render status: :created, json: Api::V4::EntrantBlueprint.render(entrant)
    else
      render status: :bad_request, json: {
        status: :bad_request,
        error:  entrant.errors.full_messages.to_sentence
      }
    end
  end

  def update
    if @entrant.update(@column => @time)
      render status: :ok, json: Api::V4::EntrantBlueprint.render(@entrant, root: :entrant)
    else
      render status: :bad_request, json: {
        status: :bad_request,
        error:  @entrant.errors.full_messages.to_sentence
      }
    end
  end

  def destroy
    if @entrant.destroy
      head :reset_content
    else
      render status: :conflict, json: {
        status: :conflict,
        error:  @entrant.errors.full_messages.to_sentence
      }
    end
  end

  private

  def set_time
    @time = Time.now.utc
    @time = Time.at(params[:server_time].to_f / 1000).utc if params[:server_time].present?
  end

  def set_user
    doorkeeper_authorize!(:manage_race) if headers['Authorization'].present?
    self.current_user = User.find_by(id: doorkeeper_token.try(:resource_owner_id))
    head :unauthorized if current_user.nil?
  end

  def set_raceable(klass)
    @raceable = klass.where(
      'LEFT(id::text, ?) = ?',
      params[:race].length,
      params[:race]
    ).order(created_at: :asc).first
    raise ActiveRecord::RecordNotFound if @raceable.nil?
    return unless @raceable.secret_visibility? && !@raceable.joinable?(user: current_user, token: params[:join_token])

    head :unauthorized
  rescue ActiveRecord::RecordNotFound
    render not_found(klass.type)
  end

  def set_entrant
    @entrant = Entrant.find_by(user: current_user, raceable: @raceable)
    raise ActiveRecord::RecordNotFound if @entrant.nil?
  rescue ActiveRecord::RecordNotFound
    render not_found(:entrant)
  end

  def set_column
    @column = nil
    columns = %i[readied_at finished_at forfeited_at].freeze
    columns.each do |param|
      if @column.present? && params[param].present?
        render status: :bad_request, json: {
          status: :bad_request,
          error:  'Only supply one parameter to update'
        }
        return nil # return nil to satisfy rubocop
      end

      @column = param if params[param].present?
    end
    return unless @column.nil?

    render status: :bad_request, json: {
      status: :bad_request,
      error:  "Specify at least one parameter to update: #{columns}"
    }
  end
end
