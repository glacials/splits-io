class BroadcastUploadJob < ApplicationJob
  # Adding or deleting a job? Reflect the change in the QUEUES environment variable in docker-compose.yml and
  # docker-compose-production.yml.
  queue_as :broadcast_upload

  def perform(run)
    RunChannel.broadcast_to(
      run,
      time_since_upload: ApplicationController.render(partial: 'runs/time_since_upload', locals: {run: run})
    )
  end
end
