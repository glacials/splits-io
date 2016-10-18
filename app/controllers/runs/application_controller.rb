class Runs::ApplicationController < ApplicationController
  private

  def set_run
    @run = Run.find_by(id: params[:run].to_i(36)) || Run.find_by!(nick: params[:run])
    gon.run = {id: @run.id36, splits: @run.collapsed_splits}
    gon.scale_to = @run.time
  rescue ActionController::UnknownFormat, ActiveRecord::RecordNotFound
    not_found
  end
end
