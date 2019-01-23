class SearchController < ApplicationController
  before_action :set_query, only: [:index]

  def index
    @results = {}
    return if @query.blank?

    @results[:games] = Game.search(@query).order(:name).includes(:categories)
    @results[:users] = User.search(@query).includes(:games)
  end

  private

  def set_query
    @query = params[:q].strip if params[:q].present?
  end
end
