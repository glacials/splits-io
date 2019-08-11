class Users::PbsController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_game, only: [:show]
  before_action :set_category, only: [:show]

  def show
    if @user.has_redirectors?
      if params[:trailing_path].nil?
        redirect_to run_path(@user.pb_for(Run::REAL, @category))
      else
        redirect_to "#{run_path(@user.pb_for(Run::REAL, @category))}/#{params[:trailing_path]}"
      end
    else
      redirect_to user_path(@user), alert: 'Redirectors are not enabled for this account.'
    end
  end

  private

  def set_user
    @user = User.find_by(name: params[:user]) || not_found
  end

  def set_game
    @game = Game.joins(:srdc).find_by(speedrun_dot_com_games: {shortname: params[:game]}) || Game.find_by(id: params[:game])

    not_found if @game.nil?
  end

  def set_category
    @category = @game.categories.where(shortname: params[:category]).or(
      @game.categories.where(id: params[:category])
    ).first

    not_found if @category.nil?
  end
end
