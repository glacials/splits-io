class Api::V4::RunnersController < Api::V4::ApplicationController
  before_action :set_runner

  def show
    render json: @runner, serializer: Api::V4::RunnerSerializer
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
end
