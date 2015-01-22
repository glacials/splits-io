class UsersController < ApplicationController
  before_action :set_user, only: [:show, :follows]

  def show
    # temporary
    @user.runs.each do |run|
      run.delay.refresh_from_file if rand(100) == 0
    end
  end

  def follows
    render partial: "shared/follows"
  end

  private

  def set_user
    @user = User.find_by(name: params[:id]) || not_found
  end
end
