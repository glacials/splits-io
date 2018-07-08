class Api::Webhooks::ParseController < ApplicationController
  before_action :set_run, only: [:create]

  def create
    return if @run.parsed_at.present?
    @run.parse_into_db
    head :ok
  end

  private

  def set_run
    @run = Run.find_by(s3_filename: params[:s3_filename])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end
end
