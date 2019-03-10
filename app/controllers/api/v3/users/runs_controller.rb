class Api::V3::Users::RunsController < Api::V3::ApplicationController
  before_action :set_user
  before_action :set_runs, only: [:index]

  def index
    runs = paginate @runs
    render json: Api::V3::RunBlueprint.render(runs, root: :runs)
  end

  private

  def set_user
    @user = User.find_by(name: params[:user_id]) || User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: {status: 404, message: "User with name or id '#{params[:user_id]}' not found."}
  end

  def set_runs
    @runs = @user.runs.includes(:game, :category)
  end
end
