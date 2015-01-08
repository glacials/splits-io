class CategoriesController < ApplicationController
  before_action :set_game
  before_action :set_category

  def show
    # temporary
    @category.runs.each do |run|
      run.delay.refresh_from_file
    end
  end

  private

  def set_game
    @game = Game.find_by(shortname: params[:game_shortname])
    redirect_to search_path(params[:game_shortname]) if @game.nil?
  end

  def set_category
    @category = @game.categories.find_by(shortname: params[:category_shortname]) ||
                @game.categories.find_by(id: params[:category_shortname])
    redirect_to search_path(params[:game_shortname]) if @category.nil?
  end
end
