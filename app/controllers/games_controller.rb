class GamesController < ApplicationController
  before_action :set_game,              only: %i[show edit update]
  before_action :set_games,             only: %i[index]
  before_action :redirect_if_not_found, only: %i[show edit update]
  before_action :authorize,             only: %i[edit update]

  def index
  end

  def show
    @on_game_page = true
    @category = @game.categories.joins(:runs).group('categories.id').order('count(runs.id) desc').first
    if @category.nil?
      render :not_found, status: :not_found
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
    @game = Game.joins(:srdc).find_by(speedrun_dot_com_games: {shortname: params[:game]}) ||
            Game.find_by(id: params[:game])
  end

  def redirect_if_not_found
    if @game.nil?
      redirect_to games_path(q: params[:game])
      return
    end
    redirect_to game_path(@game) if @game.srdc.try(:shortname).present? && params[:game] == @game.id.to_s
  end

  def set_games
    @games = Hash.new([])
    SpeedrunDotComGame.order('ASCII(name) ASC').each do |game|
      @games[game.name[0].downcase] += [game]
    end
  end
end
