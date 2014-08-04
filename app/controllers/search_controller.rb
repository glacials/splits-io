class SearchController < ApplicationController
  def index
    if params[:q]
      redirect_to search_path(params[:q].strip)
    elsif params[:term].present?
      @term = params[:term].strip
      puts "hi #{@term}"
      @result = {}
      @result[:games] = Game.search(@term)
      @result[:runs]  = Run.search(@term).page(params[:page])
    end
  end
end
