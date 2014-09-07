class SearchController < ApplicationController
  def index
    if params[:q]
      redirect_to search_path(params[:q].strip)
    elsif params[:term].present?
      @term = params[:term].strip
      @result = {}
      @result[:users] = User.search(@term).page(params[:page])
      @result[:games] = Game.search(@term)
      @result[:runs]  = Run.search(@term).page(params[:page])
    end
  end
end
