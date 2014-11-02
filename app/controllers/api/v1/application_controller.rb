class Api::V1::ApplicationController < ApplicationController
  respond_to :json

  before_action :check_params, only: [:index]
  before_action :set_records, only: [:index]
  before_action :set_record, only: [:show]

  private

  def check_params
    if search_conditions.empty?
      render status: 400, json: {
        status: 400,
        error: "You must supply one or more of the following parameters: #{safe_params.join(", ")}"
      }
      return
    end
  end

  def set_records
    @records = model.where(search_conditions)
  end

  def set_record
    @record = model.find params.require(:id)
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {
      status: 404,
      error: "No #{model.to_s.downcase} with id '#{params[:id]}' found.",
      suggestions: safe_params.map do |safe_param|
        "If #{params[:id]} is a #{model.to_s.downcase}'s #{safe_param}, do GET #{root_url}api/v1/#{model.to_s.downcase.pluralize}?#{safe_param}=#{params[:id]}"
      end
    }
  end

  def search_conditions
    params.permit(safe_params)
  end
end
