class Games::AliasesController < ApplicationController
  before_action :set_game, only: [:create]
  before_action :set_game_to_merge, only: [:create]
  before_action :authorize, only: [:create]

  def create
    if @game_to_merge.id == @game.id
      redirect_to(
        edit_game_path(@game),
        notice: "#{@game_to_merge} is already one with #{@game}, so nothing changed."
      )
      return
    end

    @game_to_merge.merge_into!(@game)
    redirect_to edit_game_path(@game), notice: "Done! #{@game_to_merge} is now part of #{@game}."
  end

  private

  def alias_params
    params.require(:game_alias)
  end

  def authorize
    if cannot?(:edit, @game) || cannot?(:edit, @game_to_merge)
      redirect_to game_path(@game), alert: "You don't have permission to do that."
    end
  end

  def set_game
    @game = Game.joins(:srdc).find_by(speedrun_dot_com_games: {shortname: params[:game]}) || Game.find_by(id: params[:game])

    redirect_to games_path(q: params[:game]) if @game.nil?
  end

  def set_game_to_merge
    @game_to_merge = Game.from_name(alias_params[:name])

    if @game_to_merge.nil?
      redirect_to(
        edit_game_path(@game),
        alert: "Error: No game called #{alias_params[:name]} exists."
      )
    end
  end
end
