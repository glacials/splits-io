class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy]
  before_action :verify_ownership, only: [:destroy]

  def show
  end

  def destroy
    current_user.runs.destroy_all if params[:destroy_runs] == '1'
    current_user.destroy
    auth_session.invalidate!
    redirect_to root_path, alert: 'Your account has been deleted. Go have fun outside :)'
  end

  private

  def set_user
    @user = User.find_by(name: params[:user]) || not_found
  end

  def verify_ownership
    render :unauthorized, status: 401 unless @user == current_user
  end
end
