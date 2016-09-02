class Api::V4::Runs::UsersController < Api::V4::ApplicationController
  before_action :set_run
  before_action :verify_ownership!

  def destroy
    @run.update(user: nil)
  end
end
