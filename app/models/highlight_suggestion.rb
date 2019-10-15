class HighlightSuggestion < ApplicationRecord
  belongs_to :run

  validates :run, uniqueness: true

  class << self
    # from_run looks on Twitch for past broadcasts whose timestamps show that it contains the given run's PB. If found,
    # the highlight suggestion is created and returned. If not found, nothing is created and something falsey is
    # returned.
    def from_run(run)
      return if run.user.nil? || run.user.twitch.nil?

      return run.highlight_suggestion if run.highlight_suggestion.present?

      pb = run.histories.where.not(started_at: nil).where.not(ended_at: nil).find_by(
        realtime_duration_ms: run.duration(Run::REAL).to_ms,
        gametime_duration_ms: run.duration(Run::GAME).to_ms
      )
      return if pb.nil?

      run.user.twitch.videos.each do |video|
        match = /^((\d+)h)?((\d+)m)?((\d+)s)?$/.match(video['duration'])

        hours   = match[2].to_i.hours
        minutes = match[4].to_i.minutes
        seconds = match[6].to_i.seconds

        video_start    = DateTime.parse(video['created_at'])
        video_end      = video_start + hours + minutes + seconds
        # subtracting DateTimes gives fractional days; we want seconds
        video_duration = (video_end - video_start) * 1.day
        next unless video_start - 30.seconds < pb.started_at && video_end + 30.seconds > pb.ended_at

        video_time_at_pb_start = pb.started_at - video_start
        video_time_at_pb_end   = video_time_at_pb_start + (pb.duration(Run::REAL).to_ms / 1000)

        highlight_suggestion = create(
          run: run,
          url: URI.parse("https://www.twitch.tv/#{run.user.twitch.name}/manager/highlighter/#{video['id']}").tap do |uri|
            uri.query = {
              start: [0, (video_time_at_pb_start - 10.seconds).to_i].max,
              end:   [video_duration.to_i, (video_time_at_pb_end + 10.seconds).to_i].min,
              title: "PB: #{run.game} #{run.category} in #{run.duration(run.default_timing).format}"
            }.to_query
          end
        )
        if highlight_suggestion.persisted?
          # 60 days is life of archives for Partners / Twitch Prime members
          HighlightCleanupJob.set(wait_until: video_start + 60.days).perform_later(highlight_suggestion)
        end
        return highlight_suggestion
      end

      nil
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error([e.message, *e.backtrace].join($RS))
      Rollbar.error(e, response: e.response)
      nil
    end
  end
end
