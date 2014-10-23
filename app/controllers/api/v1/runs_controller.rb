class Api::V1::RunsController < ApplicationController

  def show
    render @run
  end

  private

  def set_run
    @run = Run.find params[:id]
  end

end
