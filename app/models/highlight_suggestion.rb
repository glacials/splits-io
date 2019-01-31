class HighlightSuggestion < ApplicationRecord
  belongs_to :run

  validates_uniqueness_of :run

  class << self
    # from_run looks on Twitch for past broadcasts whose timestamps show that it contains the given run's PB. If found,
    # the highlight suggestion is created and returned. If not found, nothing is created and something falsey is
    # returned.
    def from_run(run)
      return if run.user.nil? || run.user.twitch.nil?

      pb = run.histories.where.not(started_at: nil, ended_at: nil).find_by(
        realtime_duration_ms: run.duration_ms(Run::REAL),
        gametime_duration_ms: run.duration_ms(Run::GAME)
      )
      return if pb.nil?

      Twitch::Videos.recent(run.user.twitch.twitch_id, type: :archive).each do |video|
        match = /^((\d+)h)?((\d+)m)?((\d+)s)?$/.match(video['duration'])
        hours   = match[2].to_i.hours
        minutes = match[4].to_i.minutes
        seconds = match[6].to_i.seconds

        video_start = DateTime.parse(video['created_at'])
        video_end   = video_start + hours + minutes + seconds

        if video_start - 30.seconds < pb.started_at && video_end + 30.seconds > pb.ended_at
          highlight_suggestion = create(
            run: run,
            url: URI.parse("https://www.twitch.tv/#{run.user.twitch.name}/manager/highlighter/#{video['id']}").tap do |uri|
              uri.query = {
                start: (pb.started_at - video_start - 10.seconds).to_i,
                end: ((pb.started_at - video_start) + (pb.duration_ms(Run::REAL) / 1000) + 10.seconds).to_i,
                title: "PB: #{run.game} #{run.category} in #{Duration.new(run.duration_ms(run.default_timing)).format}"
              }.to_query
            end
          )
          # 60 days is life of archives for Partners / Twitch Prime members
          highlight_suggestion.delay(run_at: video_start + 60.days).destroy
          return highlight_suggestion
        end
      end

      nil
    end
  end
end
