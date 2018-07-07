class Api::Webhooks::ParseController < ApplicationController
  def create
    return if @run.parsed_at.present?
    @run.parse_into_db
    render :ok
  end

  private

  def set_run
    @run = Run.find36(params[:run])
  rescue ActiveRecord::RecordNotFound
    render :not_found
  end
end
