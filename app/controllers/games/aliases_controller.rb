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

    if @game_to_merge.shortname.present? && @game.srdc.try(:shortname).present?
      redirect_to(
        edit_game_path(@game),
        alert: "Error: You're trying to merge two games with SRL links, which probably isn't right."
      )
      return
    end

    if @game_to_merge.shortname.present?
      redirect_to(
        edit_game_path(@game),
        alert: "Error: You can't merge a game with an SRL link into another game. Try merging the other way instead."
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
    @game = Game.find_by(shortname: params[:game])

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
