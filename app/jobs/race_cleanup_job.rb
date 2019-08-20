class RaceCleanupJob < ApplicationJob
  # Adding or deleting a job? Reflect the change in the QUEUES environment variable in docker-compose.yml and
  # docker-compose-production.yml.
  queue_as :race_cleanup

  def perform(race)
    race.entries.unfinished.unforfeited.update_all(forfeited_at: Time.now.utc)
    Api::V4::RaceBroadcastJob.perform_later(race, 'race_entries_updated', "The race has been abandoned")
  end
end
