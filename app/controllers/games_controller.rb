class GamesController < ApplicationController

  def show
    @result = {games: [@game]}
    render template: 'search/index'
  end

  private

  def set_game
    @game = Game.find_by shortname: params[:game_shortname]
    if @game.nil?
      respond_to do |format|
        format.json { render status: 404, json: {message: 'No such game exists.'} }
        format.html { render :not_found, status: 404 }
      end
    end
  end
end
