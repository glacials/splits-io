class Api::V3::UsersController < Api::V3::ApplicationController
  before_action :set_user, only: [:show]

  def show
    render json: Api::V3::UserBlueprint.render(@user, root: :user)
  end

  private

  def set_user
    @user = User.find_by(name: params[:id]) || User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: {status: 404, message: "User with name or id '#{params[:id]}' not found."}
  end
end
