class SearchController < ApplicationController
  before_action :set_query, only: [:index]
  before_action :set_search_type, only: [:index]

  def index
    return if @query.blank?
    return if @search_type.blank?

    case @search_type
    when 'game'
      @results = Game.search(@query).order(:shortname, :name).includes(:categories)
    when 'user'
      @results = User.search(@query).includes(:games)
    end
  end

  private

  def set_query
    @query = params[:q].strip if params[:q].present?
  end

  def set_search_type
    @search_type = params[:search_type]
  end
end
