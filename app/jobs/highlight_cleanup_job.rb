class HighlightCleanupJob < ApplicationJob
  # Adding or deleting a job? Reflect the change in the QUEUES environment variable in docker-compose.yml and
  # docker-compose-production.yml.
  queue_as :highlight_cleanup

  def perform(highlight_suggestion)
    return if highlight_suggestion.nil?

    highlight_suggestion.destroy
  end
end
