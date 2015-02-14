class Users::RivalriesController < ApplicationController
  before_filter :set_user
  before_filter :set_to_user, only: [:create]
  before_filter :set_category, if: Proc.new { params[:category].present? }
  before_filter :authenticate

  def new
    @rivalry = @user.rivalries.new(category: @category)
  end

  def create
    @rivalry = @user.rivalries.new(category: @category, to_user: @to_user)
    if @rivalry.save
      redirect_to(
        compare_path(@user.pb_for(@category), @to_user.pb_for(@category)),
        notice: "#{@to_user.name} is now your rival in #{@rivalry.game.name} #{@rivalry.category.name}! Here are your latest respective PBs."
      )
    end
  end

  private

  def set_user
    @user = User.find_by(name: params[:user_id]) || not_found
  end

  def set_to_user
    @to_user = User.find_by(name: params[:to_user]) || not_found
  end

  def set_category
    @category = Category.find_by(id: params[:category])
  end

  def authenticate
    @user == current_user || unauthorized
  end
end
