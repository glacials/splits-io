class HighlightCleanupJob < ApplicationJob
  queue_as :highlight_cleanup

  def perform(highlight_suggestion)
    highlight_suggestion.destroy
  end
end
