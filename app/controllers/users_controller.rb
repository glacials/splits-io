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
    if @user.nil?
      respond_to do |format|
        format.json { render status: 404, json: {message: 'No such user exists.'} }
        format.html { render :not_found, status: 404 }
      end
    end
  end
end
