class Runs::ApplicationController < ApplicationController
  private

  def set_run
    @run = Run.includes(:user, :game, :category, :segments).find_by(id: params[:run].to_i(36)) || Run.find_by!(nick: params[:run])
    gon.run = {id: @run.id36, splits: @run.collapsed_segments}
    gon.scale_to = @run.duration_milliseconds
  rescue ActionController::UnknownFormat, ActiveRecord::RecordNotFound
    not_found
  end
end
