class RefreshGameJob < ApplicationJob
  queue_as :refresh_game

  def perform(game, category)
    game.sync_with_srdc
    game.sync_with_srl
    category.sync_with_srdc
  end
end
