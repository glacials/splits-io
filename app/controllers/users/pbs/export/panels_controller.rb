class Users::Pbs::Export::PanelsController < ApplicationController
  before_action :set_user
  before_action :set_runs

  def index
    render layout: false, content_type: 'text/plain'
  end

  private

  def set_user
    @user = User.find_by!(name: params[:user])
  end

  def set_runs
    @runs = @user.pbs.categorized
  end
end
