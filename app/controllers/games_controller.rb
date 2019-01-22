class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update]
  before_action :authorize, only: [:edit, :update]

  def show
    @on_game_page = true
    @category = @game.categories.joins(:runs).group('categories.id').order('count(runs.id) desc').first
    if @category.nil?
      render :not_found, status: 404
      return
    end
    render template: 'games/categories/show'
  end

  def edit
  end

  def update
  end

  private

  def authorize
    redirect_to game_path(@game), alert: "You don't have permission to do that." if cannot?(:edit, @game)
  end

  def set_game
    @game = Game.joins(:srdc).find_by(speedrun_dot_com_games: {shortname: params[:game]}) || Game.find_by(id: params[:game])

    if @game.nil?
      redirect_to games_path(q: params[:game])
      return
    end
    redirect_to game_path(@game) if @game.srdc.try(:shortname).present? && params[:game] == @game.id.to_s
  end
end
