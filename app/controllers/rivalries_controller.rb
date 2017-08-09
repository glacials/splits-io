class RivalriesController < ApplicationController
  before_filter :set_rivalry,  only: [:destroy]
  before_filter :set_target,   only: [:create]
  before_filter :set_category, only: [:new, :create], if: -> { params[:category].present? }

  def index
    @rivalries = current_user.rivalries
  end

  def new
    @rivalry = current_user.rivalries.new(category: @category)
  end

  def create
    Rivalry.transaction do
      current_user.rivalries.for_category(@category).destroy_all
      if current_user.rivalries.create(category: @category, to_user: @target)
        redirect_to(
          compare_path(current_user.pb_for(@category), @target.pb_for(@category)),
          notice: "#{@target} is now your rival in #{@category.game} #{@category}. Here are your latest PBs."
        )
      end
    end
  end

  def destroy
    if cannot?(:destroy, @rivalry)
      unauthorized
      return
    end

    if @rivalry.destroy
      redirect_to rivalries_path, notice: 'Rivalry deleted. See? You won in the end.'
    else
      redirect_to rivalries_path, alert: "Oops, there was an error deleting your rivalry. For now you're destined to clash. Please try again in a bit."
    end
  end

  private

  def set_rivalry
    @rivalry = Rivalry.find_by(id: params[:rivalry]) || not_found
  end

  def set_target
    @target = User.find_by(name: params[:target]) || not_found
  end

  def set_category
    @category = Category.find_by(id: params[:category]) || not_found
  end
end
