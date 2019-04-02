class BroadcastUploadJob < ApplicationJob
  queue_as :broadcast_upload

  def perform(run)
    RunChannel.broadcast_to(
      run,
      time_since_upload: ApplicationController.render(partial: 'runs/time_since_upload', locals: {run: run})
    )
  end
end
