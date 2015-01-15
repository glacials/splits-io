class Users::Pbs::Export::PanelsController < ApplicationController
  before_action :set_user

  def index
    render layout: false, content_type: 'text/plain'
  end

  private

  def set_user
    @user = User.find_by!(name: params[:user_id])
  end
end
