class CleanupJobs < ActiveRecord::Migration[6.0]
  def change
    # Remove all broken destroy jobs
    Delayed::Job.all.each do |job|
      if job.name == 'HighlightSuggestion.destroy'
        job.destroy
      end
    end

    # Delete any suggestions that resulted in broken jobs
    HighlightSuggestion.where('created_at > ?', 60.days.ago) do |suggestion|
      suggestion.destroy
    end
  end
end
