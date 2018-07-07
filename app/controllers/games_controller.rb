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
    shortname = params[@game.id.to_s][:shortname].presence

    if @game.update(shortname: shortname)
      redirect_to(
        edit_game_path(@game),
        notice: if shortname.present?
                  "Saved! #{@game.name} now has the shortname '#{@game.shortname}'."
                else
                  "Saved! #{@game.name} no longer has a shortname."
                end
      )
    else
      redirect_to(
        edit_game_path(@game),
        alert: "Couldn't update #{@game.name}'s shortname to '#{@game.shortname}'."
      )
    end
  end

  private

  def authorize
    redirect_to game_path(@game), alert: "You don't have permission to do that." if cannot?(:edit, @game)
  end

  def set_game
    @game = Game.find_by(shortname: params[:game]) || Game.find_by(id: params[:game])

    redirect_to games_path(q: params[:game]) if @game.nil?
    redirect_to game_path(@game) if @game.shortname.present? && params[:game] == @game.id.to_s
  end
end
