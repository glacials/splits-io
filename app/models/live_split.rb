require 'xmlsimple'

module LiveSplit
  class Run < Run
    def self.sti_name
      :livesplit
    end
  end

  class Split < Split
  end

  class Parser
    def parse(xml)
      xml = XmlSimple.xml_in(xml)
      version = Versionomy.parse(xml['version'] || '1.2')
      return v1_5(xml) if version >= Versionomy.parse('1.5')
      return v1_4(xml) if version >= Versionomy.parse('1.4')
      return v1_3(xml) if version >= Versionomy.parse('1.3')
      return v1_2(xml) if version >= Versionomy.parse('1.2')
      return nil
    rescue
      nil
    end

    private

    # file format 1.5 is used by LiveSplit 1.6.x
    def v1_5(xml)
      run = {
        game: xml['GameName'][0].try(:strip),
        category: xml['CategoryName'][0].try(:strip),
        attempts: xml['AttemptCount'][0].try(:strip),
        offset: duration_in_seconds_of(xml['Offset'][0].try(:strip)),
        history: (xml['AttemptHistory'][0]['Time'].presence || []).map do |t|
          duration_in_seconds_of(t['content'])
        end.reject { |t| t == 0 },
        splits: [],
        time: 0,
        history: (xml['AttemptHistory'][0]['Time'] || []).map do |t|
          duration_in_seconds_of(t['RealTime'].try(:[], 0))
        end.reject { |t| t == 0 }.uniq
      }.tap { |run| run[:name] = "#{run[:game]} #{run[:category]}" }

      run[:splits] = xml['Segments'][0]['Segment'].map do |segment|
        split = Split.new
        split.best = Split.new
        split.name = segment['Name'][0].presence || ''

        split.finish_time = duration_in_seconds_of(segment['SplitTimes'][0]['SplitTime'].select do |k, _|
          k['name'] == 'Personal Best'
        end[0]['RealTime'].try(:[], 0) || '00:00:00.00')
        split.duration = [0, split.finish_time - run[:time]].max

        split.best.duration = duration_in_seconds_of(segment['BestSegmentTime'][0]['RealTime'].try(:[], 0))
        split.gold = split.duration > 0 && split.duration.round(5) <= split.best.try(:duration).try(:round, 5)
        split.skipped = split.duration == 0

        split.history = segment['SegmentHistory'][0]['Time'].try do |times|
          times.map { |time| duration_in_seconds_of(time['RealTime'].try(:[], 0).try(:strip)) }
        end

        run[:time] += split.duration if split.duration.present?
        split
      end

      # it's possible to get here with valid xml without this actually being a livesplit file, so let's make sure
      if [run[:attempts], run[:offset], run[:splits], run[:time]].any?(&:nil?)
        raise "Not a proper LiveSplit run file"
      end

      run
    end

    # LiveSplit parsing pre-1.6 waterfalls down to the lowest version possible. For instance, 1.3 and 1.2 parse almost
    # identically except for a minor difference in positioning of split times. So the 1.3 function parses only splits,
    # then hands the rest of the XML off to the 1.2 function, which parses the rest as if it were 1.2 content.

    # file format 1.4 is used by LiveSplit 1.4.x and LiveSplit 1.5.x
    def v1_4(xml, run = {})
      run[:splits]  ||= []
      run[:time]    ||= 0
      run[:history] ||= (xml['RunHistory'][0]['Time'] || []).map do |t|
        duration_in_seconds_of(t['RealTime'].try(:[], 0))
      end.reject { |t| t == 0 }.uniq
      if run[:splits].empty?
        xml['Segments'][0]['Segment'].each do |segment|
          split = Split.new
          split.best = Split.new
          split.name = segment['Name'][0].present? ? segment['Name'][0] : ''

          split.finish_time = duration_in_seconds_of(segment['SplitTimes'][0]['SplitTime'].select do |k, _|
            k['name'] == 'Personal Best'
          end[0]['RealTime'].try(:[], 0) || '00:00:00.00')
          split.duration = split.finish_time - run[:time]
          split.duration = 0 if split.duration < 0

          best_segment = segment['BestSegmentTime'][0]['RealTime'].try(:[], 0)
          split.best.duration = duration_in_seconds_of(best_segment)
          split.gold = split.duration > 0 && split.duration.round(5) <= split.best.try(:duration).try(:round, 5)
          split.skipped = split.duration == 0

          split.history = segment['SegmentHistory'][0]['Time'].try do |times|
            times.map { |time| duration_in_seconds_of(time['RealTime'].try(:[], 0).try(:strip)) }
          end

          run[:time] += split.duration if split.duration.present?
          run[:splits] << split
        end
      end
      v1_3(xml, run)
    end

    # lss file format 1.3 is used by LiveSplit 1.3.x
    def v1_3(xml, run = {})
      run[:splits] ||= []
      run[:time]   ||= 0
      if run[:splits].empty?
        xml['Segments'][0]['Segment'].each do |segment|
          split = Split.new
          split.best = Split.new
          split.name = segment['Name'][0].present? ? segment['Name'][0] : ''

          # Okay what the hell. There's no way XML parsing is this crazy.
          # Somebody please enlighten me. Maybe I should switch this to Nokogiri.
          split.finish_time = duration_in_seconds_of(segment['SplitTimes'].first.first.second.select do |k, _|
            k['name'] == 'Personal Best'
          end.first['content'].strip)
          split.duration = split.finish_time - run[:time]
          split.duration = 0 if split.duration < 0

          best_segment = segment['BestSegmentTime'][0]
          best_segment = best_segment[0] if best_segment.is_a?(Hash)
          split.best.duration = duration_in_seconds_of(best_segment)
          split.gold = split.duration > 0 && split.duration.round(5) == split.best.try(:duration).try(:round, 5)
          split.skipped = split.duration == 0

          split.history = segment['SegmentHistory'][0]['Time'].try do |times|
            times.map { |time| duration_in_seconds_of(time['content'].strip) }
          end

          run[:time] += split.duration if split.duration.present?
          run[:splits] << split
        end
      end
      v1_2(xml, run)
    end

    # lss file format 1.2 is used by LiveSplit 1.2.x and below
    def v1_2(xml, run = {})
      run[:game]     ||= xml['GameName'][0].try(:strip)
      run[:category] ||= xml['CategoryName'][0].try(:strip)
      run[:attempts] ||= xml['AttemptCount'][0].try(:strip)
      run[:offset]   ||= duration_in_seconds_of(xml['Offset'][0].try(:strip))
      run[:history]  ||= xml['RunHistory'][0]['Time'].present? ? xml['RunHistory'][0]['Time'].map { |t| duration_in_seconds_of(t['content']) }.reject { |t| t == 0 } : []

      run[:name]     ||= "#{run[:game]} #{run[:category]}"
      run[:splits]   ||= []
      run[:time]     ||= 0
      if run[:splits].empty?
        xml['Segments'][0]['Segment'].each do |segment|
          split = Split.new
          split.best = Split.new
          split.name = segment['Name'][0].present? ? segment['Name'][0] : ''
          split.finish_time = duration_in_seconds_of(segment['PersonalBestSplitTime'][0])

          split.duration = split.finish_time - run[:time]
          split.duration = 0 if split.duration < 0
          split.best.duration = duration_in_seconds_of(segment['BestSegmentTime'][0])
          split.gold = split.duration > 0 && split.duration.round(5) == split.best.try(:duration).try(:round, 5)
          split.skipped = split.duration == 0

          split.history = segment['SegmentHistory'][0]['Time'].try do |times|
            times.map { |time| duration_in_seconds_of(time['content'].strip) }
          end

          run[:time] += split.duration if split.duration.present?
          run[:splits] << split
        end
      end

      # it's possible to get here with valid xml without this actually being a livesplit file, so let's make sure
      if [run[:attempts], run[:offset], run[:splits], run[:time]].any?(&:nil?)
        raise "Not a proper LiveSplit run file"
      end

      run
    end

    def duration_in_seconds_of(time)
      return 0 if time.blank?

      time.sub!('.', ':') if time.count('.') == 2
      ChronicDuration.parse(time, keep_zero: true)
    end
  end
end
