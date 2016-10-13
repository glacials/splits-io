class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update]
  before_action :authorize, only: [:edit, :update]
  before_action :set_query, only: [:index]
  before_action :set_games, only: [:index]

  def index
  end

  def show
    @category = @game.categories.first
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
    if cannot?(:edit, @game)
      redirect_to game_path(@game), alert: "You don't have permission to do that."
    end
  end

  def set_game
    @game = Game.find_by(shortname: params[:game]) || Game.find_by(id: params[:game])

    if @game.nil?
      redirect_to games_path(q: params[:game])
    end
  end

  def set_query
    @query = params[:q].strip if params[:q].present?
  end

  def set_games
    @games = @query.present? ? Game.search(@query).includes(:categories) : []
  end
end
