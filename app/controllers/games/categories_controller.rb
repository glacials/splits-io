class Games::CategoriesController < ApplicationController
  before_action :set_game
  before_action :set_category

  def show
    # temporary
    @category.runs.each do |run|
      run.delay.refresh_from_file if rand < SplitsIO::Application.config.run_refresh_chance
    end
  end

  private

  def set_game
    @game = Game.find_by(shortname: params[:game_id])
    redirect_to game_path(params[:game_id]) if @game.nil?
  end

  def set_category
    @category = @game.categories.find_by(shortname: params[:id]) ||
                @game.categories.find_by(id: params[:id])
    redirect_to game_path(params[:game_id]) if @category.nil?
  end
end
