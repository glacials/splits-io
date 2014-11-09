class UsersController < ApplicationController
  before_action :set_user, only: :show

  def show
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @user.runs }
    end
  end

  def follows
    render partial: "shared/follows"
  end

  private

  def set_user
    @user = User.find_by(name: params[:id])
    if @user.nil?
      respond_to do |format|
        format.json { render status: 404, json: {status: 404, error: "Run not found"} }
        format.html { render :not_found, status: 404 }
      end
    end
  rescue ActionController::UnknownFormat
    render status: 404, text: "404 User not found"
  end
end
