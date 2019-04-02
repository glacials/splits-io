class RunChannel < ApplicationCable::Channel
  def subscribed
    run = Run.find36(params[:run_id])
    stream_for(run)
  end
end
