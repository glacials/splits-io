class UsersController < ApplicationController
  before_action :set_user, only: [:show, :follows]

  def show
    # temporary
    @user.runs.without(:file).each do |run|
      run.delay.refresh_from_file
    end
  end

  def follows
    render partial: "shared/follows"
  end

  private

  def set_user
    @user = User.find_by(name: params[:id])
    render :not_found, status: 404 if @user.nil?
  end
end
