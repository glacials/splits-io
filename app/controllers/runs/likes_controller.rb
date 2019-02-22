class Runs::LikesController < Runs::ApplicationController
  before_action :set_run,      only: [:create]
  before_action :set_run_like, only: [:destroy]

  def create
    if cannot?(:create, RunLike)
      redirect_to run_path(@run_like.run), alert: 'You do not have permission to like this run.'
      return
    end

    RunLike.create(user: current_user, run: @run)
    head :created
  end

  def destroy
    if cannot?(:destroy, @run_like)
      redirect_to run_path(@run_like.run), alert: 'You do not have permission to unlike this run.'
      return
    end

    @run_like.destroy
    head :no_content
  end

  private

  def set_run
    @run = Run.find_by(id: params[:run].to_i(36))
    head :not_found if @run.nil?
  end
  
  def set_run_like
    @run_like = RunLike.find_by(user: current_user, run: Run.find_by(id: params[:run].to_i(36)))
    head :not_found if @run_like.nil?
  end
end
