class HighlightCleanupJob < ApplicationJob
  queue_as :highlight_cleanup

  def perform(highlight_suggestion)
    return if highlight_suggestion.nil?

    highlight_suggestion.destroy
  end
end
