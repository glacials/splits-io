class Api::V4::RunnersController < Api::V4::ApplicationController
  before_action :set_runer

  def show
  end

  def categories
  end

  def games
  end

  def pbs
  end

  def predictions
  end

  def runs
  end

  private

  def set_runner
    @runner = User.with_runs.find_by!(name: params[:id])
  rescue ActiveRecord::RecordNotFound
    render not_found(:runner, params[:id])
  end

end
