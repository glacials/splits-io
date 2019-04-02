class CleanupJobs < ActiveRecord::Migration[6.0]
  def change
    # Remove all broken destroy jobs
    Delayed::Job.all.each do |job|
      case j.name
      when 'HighlightSuggestion.destroy'
        # This job is broken
        job.destroy
      when 'HighlightSuggestion#destroy'
        run = Run.find(job.payload_object.run_id)
        HighlightCleanupJob.set(wait: (Time.now.utc - job.run_at).seconds).perform_later(run.highlight_suggestion)
      when 'RunChannel.broadcast_time_since_upload'
        run = Run.find36(job.payload_object.args.first)
        BroadcastUploadJob.set(wait: (Time.now.utc - job.run_at).seconds).perform_later(run)
      when 'Run#refresh_game'
        run = job.payload_object.object
        RefreshGameJob.perform_later(run.game, run.category)
      when 'Delayed::PerformableMethod'
        # These jobs are highlight suggestions that are deleted
        job.destory
      end
    end

    # Delete any suggestions that resulted in broken jobs
    HighlightSuggestion.where('created_at > ?', 60.days.ago) do |suggestion|
      suggestion.destroy
    end
  end
end
