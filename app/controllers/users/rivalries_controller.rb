class Users::RivalriesController < ApplicationController
  before_filter :set_rivalry, only: [:destroy]
  before_filter :set_user
  before_filter :set_to_user, only: [:create]
  before_filter :set_category, only: [:new, :create], if: -> { params[:category].present? }
  before_filter :authenticate

  def index
  end

  def new
    @rivalry = @user.rivalries.new(category: @category)
  end

  def create
    Rivalry.transaction do
      @user.rivalries.for_category(@category).destroy_all
      if @user.rivalries.create(category: @category, to_user: @to_user)
        redirect_to(
          compare_path(@user.pb_for(@category), @to_user.pb_for(@category)),
          notice: "#{@to_user.name} is now your rival in #{@category.game} #{@category}. Here are your latest PBs."
        )
      end
    end
  end

  def destroy
    if @rivalry.destroy
      redirect_to user_rivalries_path(@user), notice: 'Rivalry deleted. See? You won in the end.'
    else
      redirect_to user_rivalries_path(@user), alert: "Oops, there was an error deleting your rivalry. For now you're destined to clash. Please try again in a bit."
    end
  end

  private

  def set_rivalry
    @rivalry = Rivalry.find_by(id: params[:id]) || not_found
  end

  def set_user
    @user = User.find_by(name: params[:user_id]) || not_found
  end

  def set_to_user
    @to_user = User.find_by(name: params[:to_user]) || not_found
  end

  def set_category
    @category = Category.find_by(id: params[:category]) || not_found
  end

  def authenticate
    @user == current_user || unauthorized
  end
end
