class UsersController < ApplicationController
  before_action :set_user, only: :show

  def show
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @user.runs }
    end
  end

  private

  def set_user
    @user = User.find_by(name: params[:user])
    render :bad_url if @user.nil?
  end
end
