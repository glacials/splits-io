class UsersController < ApplicationController
  before_action :set_user, only: :show

  private

  def set_user
    @user = User.find_by(name: params[:user])
    render :bad_url if @user.nil?
  end

end
