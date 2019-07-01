class RefreshGameJob < ApplicationJob
  # Adding or deleting a job? Reflect the change in the QUEUES environment variable in docker-compose.yml and
  # docker-compose-production.yml.
  queue_as :refresh_game

  def perform(game, category)
    game.sync_with_srdc
    game.sync_with_srl
    category.sync_with_srdc
  end
end
