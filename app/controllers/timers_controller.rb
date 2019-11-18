class TimersController < ApplicationController
  before_action :set_timer

  def show
  end

  private

  def set_timer
    @timer = Run.program(params[:timer_id])

    not_found if @timer.nil?
  end
end
