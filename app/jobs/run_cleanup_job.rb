class RunCleanupJob < ApplicationJob
  # Adding or deleting a job? Reflect the change in the QUEUES environment variable in docker-compose.yml and
  # docker-compose-production.yml.
  queue_as :cleanup_runs

  def perform(run)
    return if run.nil?
    return unless run.file.nil?

    run.destroy
  end
end
