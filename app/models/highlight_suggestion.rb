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
            url: URI.parse("https://www.twitch.tv/#{run.user.twitch.name}/manager/highlighter/#{video['id']}").tap do |uri|
              uri.query = {
                start: (pb.started_at - video_start - 10.seconds).to_i,
                end: ((pb.started_at - video_start) + (pb.duration_ms(Run::REAL) / 1000) + 10.seconds).to_i,
                title: "PB: #{run.game} #{run.category} in #{format_ms(run.duration_ms(run.default_timing))}"
              }.to_query
            end
          )
          delay(run_at: 60.days.from_now).destroy # 60 days is life of archives for Partners / Twitch Prime members
          return highlight_suggestion
        end
      end

      nil
    end

    # format_ms accepts a number of milliseconds and returns a time like "HH:MM:SS". If precise is true, it returns a time
    # like "HH:MM:SS.mmm" instead.
    def format_ms(milliseconds, precise: false)
      return '-' if milliseconds.nil?
      time = explode_ms(milliseconds)

      return format('%02d:%02d:%02d.%03d', time[:h], time[:m], time[:s], time[:ms]) if precise
      format('%02d:%02d:%02d', time[:h], time[:m], time[:s])
    end

    # explode_ms returns a hash with the components of the given duration separated out. The returned hash is guaranteed
    # to be ordered by component size descending (hours before minutes, etc.).
    def explode_ms(total_milliseconds)
      total_seconds = total_milliseconds / 1000
      total_minutes = total_seconds / 60
      total_hours   = total_minutes / 60

      {
        h:  total_hours,
        m:  total_minutes % 60,
        s:  total_seconds % 60,
        ms: total_milliseconds % 1000
      }
    end
  end
end
