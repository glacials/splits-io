class RunChannel < ApplicationCable::Channel
  def subscribed
    run = Run.find36(params[:run_id])
    stream_for(run)
  end

  class << self
    def broadcast_time_since_upload(id36)
      run = Run.find36(id36)
      RunChannel.broadcast_to(
        run,
        time_since_upload: ApplicationController.render(partial: 'runs/time_since_upload', locals: {run: run})
      )
    end
  end
end
