class Users::PbsController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_game, only: [:show]
  before_action :set_category, only: [:show]

  def show
    if @user.gold_patron?
      redirect_to run_path(@user.pb_for(@category))
    else
      redirect_to user_path(@user), alert: 'Redirectors are not enabled for this account.'
    end
  end

  private

  def set_user
    @user = User.find_by(name: params[:user]) || not_found
  end

  def set_game
    @game = Game.where(shortname: params[:game]).or(Game.where(id: params[:game])).first

    if @game.nil?
      not_found
    end
  end

  def set_category
    @category = @game.categories.where(shortname: params[:category]).or(
      @game.categories.where(id: params[:category])
    ).first

    if @category.nil?
      not_found
    end
  end
end
