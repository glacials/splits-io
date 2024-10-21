class GamesController < ApplicationController
  before_action :set_game,  only: %i[show edit update]
  before_action :authorize, only: %i[edit update]

  def show
    @on_game_page = true
    @category = @game.categories.joins(:runs).group('categories.id').order(Arel.sql('count(runs.id) desc')).first
    if @category.nil?
      render :not_found, status: :not_found
      return
    end
    render template: 'games/categories/show'
  end

  def edit
  end

  private

  def authorize
    redirect_to game_path(@game), alert: "You don't have permission to do that." if cannot?(:edit, @game)
  end

  def set_game
    games = Game.includes(:srdc, :srl)
    @game = games.joins(:srdc).find_by(speedrun_dot_com_games: {shortname: params[:game]}) ||
            games.find(id: params[:game])

    redirect_to game_path(@game) if @game.srdc.try(:shortname).present? && params[:game] == @game.id.to_s
  rescue ActiveRecord::RecordNotFound
    redirect_back(fallback_location: root_path, alert: 'Game not found.')
  end

  def set_games
    @games = Hash.new { |h, k| h[k] = [] }
    Game.joins(:runs, :srdc).order('ASCII(games.name) ASC, UPPER(games.name) ASC').each do |game|
      @games[game.name[0].downcase] << game
    end
  end
end
