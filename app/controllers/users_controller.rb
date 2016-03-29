class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy, :follows]
  before_action :verify_ownership, only: [:destroy]

  def show
  end

  def destroy
    if params[:destroy_runs] == '1'
      current_user.runs.destroy_all
    end
    current_user.destroy
    auth_session.invalidate!
    redirect_to root_path, alert: "Your account has been deleted. Go have fun outside :)"
  end

  def follows
    render partial: "shared/follows"
  end

  private

  def set_user
    @user = User.find_by(name: params[:id]) || not_found
  end

  def verify_ownership
    unless @user == current_user
      render :unauthorized, status: 401
    end
  end
end
