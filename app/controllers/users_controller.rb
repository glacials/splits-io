class UsersController < ApplicationController
  before_action :downcase, only: [:show]
  before_action :set_user, only: [:show]

  def show
  end

  private

  def set_user
    @user = User.find_by(name: params[:user]) || not_found
  end

  def downcase
    if params[:user] != params[:user].downcase
      redirect_to user_path(params[:user].downcase)
    end
  end
end
