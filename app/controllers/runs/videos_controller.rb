class Runs::VideosController < Runs::ApplicationController
  before_action :set_run, only: [:create, :update]

  def update
    if cannot?(:update, Run)
      redirect_to run_path(@run), alert: 'You do not have permission to edit this run.'
      return
    end

    if video_params[:url].blank?
      if !@run.video.nil? && !@run.video&.destroy
        redirect_to(edit_run_path(@run), alert: @run.video.errors.full_messages.to_sentence)
        return
      end

      redirect_back(fallback_location: edit_run_path(@run), notice: 'Video deleted. 📹')
      return
    end

    @run.build_video if @run.video.nil?

    if !@run.video.update(video_params)
      redirect_to(edit_run_path(@run), alert: @run.video.errors.full_messages.to_sentence)
      return
    end

    redirect_back(fallback_location: edit_run_path(@run), notice: 'Video added! 📹')
  end

  private

  def video_params
    params.require(:video).permit(:url)
  end

  def set_run
    @run = Run.find_by(id: params[:run].to_i(36))
    head :not_found if @run.nil?
  end
end
