class Api::V4::Runs::UsersController < Api::V4::ApplicationController
  before_action :set_run
  before_action only: [:destroy] do
    doorkeeper_authorize! :delete_run
  end

  def destroy
    if @run.update(user: nil)
      head 205
    else
      head 500
    end
  end
end
