class TrackJob < ApplicationJob
  # Adding or deleting a job? Reflect the change in the QUEUES environment
  # variable in docker-compose.yml and docker-compose-production.yml.
  queue_as :track

  def perform(category:, action:)
    GoogleAnalytics.track_event(
      category: category,
      action: action,
    )
  end
end
