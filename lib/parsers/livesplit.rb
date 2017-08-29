require 'xmlsimple'

module LiveSplit
  def self.to_s
    "LiveSplit"
  end

  def self.to_sym
    :livesplit
  end

  def self.file_extension
    'lss'
  end

  def self.website
    'http://livesplit.org/'
  end

  def self.content_type
    'application/livesplit'
  end

  class Parser
    def tugnut_parse(xml, fast: true)
      Tugnut.parse(xml)
    end

    # When `options[:fast] == true`, run in O(n) time, with n being the number of splits in one run.
    # Do not parse run history, split history, or other things that scale beyond O(n).
    # When `options[:fast] == false`, go nuts.
    def parse(xml, fast: true)
      xml = XmlSimple.xml_in(xml)
      version = Versionomy.parse(xml['version'] || '1.2')

      return v1_6(xml, fast) if version >= Versionomy.parse('1.6')
      return v1_5(xml, fast) if version >= Versionomy.parse('1.5')
      return v1_4(xml, fast) if version >= Versionomy.parse('1.4')
      return v1_3(xml, fast) if version >= Versionomy.parse('1.3')
      return v1_2(xml, fast) if version >= Versionomy.parse('1.2')
      return nil
    rescue
      nil
    end

    private

    # lss file format 1.6 is used by LiveSplit 1.6.x
    def v1_6(xml, fast)
      run = {
        game: xml['GameName'][0].try(:strip),
        category: xml['CategoryName'][0].try(:strip),
        srdc_id: xml['Metadata'][0]['Run'][0]['id'],
        attempts: xml['AttemptCount'][0].to_i,
        offset: duration_in_seconds_of(xml['Offset'][0].try(:strip)),
        realtime_history: fast ? nil : (xml['AttemptHistory'][0]['Attempt'] || []).map do |t|
          duration_in_seconds_of(t['RealTime'].try(:[], 0))
        end.reject { |t| t == 0 }.uniq,
        gametime_history: fast ? nil : (xml['AttemptHistory'][0]['Attempt'] || []).map do |t|
          duration_in_seconds_of(t['GameTime'].try(:[], 0))
        end.reject { |t| t == 0 }.uniq,
        splits: [],
        realtime_time: 0,
        gametime_time: 0,
      }.tap { |run| run[:name] = "#{run[:game]} #{run[:category]}".strip }

      indexed_history = {}
      (xml['AttemptHistory'][0]['Attempt'] || []).each do |t|
        if t['RealTime'].nil?
          next
        end

        indexed_history[t['id'].to_i] = duration_in_seconds_of(t['RealTime'][0].strip)
      end
      run[:indexed_history] = indexed_history

      run[:splits] = xml['Segments'][0]['Segment'].map do |segment|
        split = Split.new
        split.name = segment['Name'][0].presence || ''

        split.realtime_end = duration_in_seconds_of(segment['SplitTimes'][0]['SplitTime'].select do |k, _|
          k['name'] == 'Personal Best'
        end[0]['RealTime'].try(:[], 0) || '00:00:00.00')
        split.realtime_duration = [0, split.realtime_end - run[:realtime_time]].max
        split.realtime_start = split.realtime_end - split.realtime_duration

        split.realtime_best = duration_in_seconds_of(segment['BestSegmentTime'][0]['RealTime'].try(:[], 0))
        split.realtime_skipped = split.realtime_duration == 0

        if split.realtime_duration > 0 && split.realtime_duration.round(5) <= split.realtime_best.try(:round, 5)
          split.realtime_gold = true
        else
          split.realtime_gold = false
        end

        split.realtime_history = fast ? nil : segment['SegmentHistory'][0]['Time']
        if split.realtime_history.present?
          split.indexed_history = {}
          split.realtime_history.map! do |time|
            t = time['RealTime']
            if t.nil?
              split.indexed_history[time['id']] = nil
              0
            else
              t = duration_in_seconds_of(t[0].try(:strip))
              split.indexed_history[time['id']] = t
              t
            end
          end
        end

        split.gametime_end = duration_in_seconds_of(segment['SplitTimes'][0]['SplitTime'].select do |k, _|
          k['name'] == 'Personal Best'
        end[0]['GameTime'].try(:[], 0) || '00:00:00.00')
        split.gametime_duration = [0, split.gametime_end - run[:gametime_time]].max
        split.gametime_start = split.gametime_end - split.gametime_duration

        split.gametime_best = duration_in_seconds_of(segment['BestSegmentTime'][0]['GameTime'].try(:[], 0))
        split.gametime_skipped = split.gametime_duration == 0

        if split.gametime_duration > 0 && split.gametime_duration.round(5) <= split.gametime_best.try(:round, 5)
          split.gametime_gold = true
        else
          split.gametime_gold = false
        end

        run[:realtime_time] += split.realtime_duration if split.realtime_duration.present?
        run[:gametime_time] += split.gametime_duration if split.gametime_duration.present?
        split
      end

      # it's possible to get here with valid xml without this actually being a livesplit file, so let's make sure
      if [run[:attempts], run[:offset], run[:splits], run[:realtime_time]].any?(&:nil?)
        raise "Not a proper LiveSplit run file"
      end

      run
    end

    # lss file format 1.5 was used by some dev versions of LiveSplit 1.6.x
    def v1_5(xml, fast)
      run = {
        game: xml['GameName'][0].try(:strip),
        category: xml['CategoryName'][0].try(:strip),
        attempts: xml['AttemptCount'][0].to_i,
        offset: duration_in_seconds_of(xml['Offset'][0].try(:strip)),
        splits: [],
        realtime_time: 0,
        realtime_history: fast ? nil : (xml['AttemptHistory'][0]['Time'] || []).map do |t|
          duration_in_seconds_of(t['RealTime'].try(:[], 0))
        end.reject { |t| t == 0 }.uniq
      }.tap { |run| run[:name] = "#{run[:game]} #{run[:category]}".strip }

      indexed_history = {}
      (xml['AttemptHistory'][0]['Attempt'] || []).each do |t|
        if t['RealTime'].nil?
          next
        end

        indexed_history[t['id'].to_i] = duration_in_seconds_of(t['RealTime'][0].strip)
      end
      run[:indexed_history] = indexed_history

      run[:splits] = xml['Segments'][0]['Segment'].map do |segment|
        split = Split.new
        split.name = segment['Name'][0].presence || ''

        split.realtime_end = duration_in_seconds_of(segment['SplitTimes'][0]['SplitTime'].select do |k, _|
          k['name'] == 'Personal Best'
        end[0]['RealTime'].try(:[], 0) || '00:00:00.00')
        split.realtime_duration = [0, split.realtime_end - run[:realtime_time]].max
        split.realtime_start = split.realtime_end - split.realtime_duration

        split.realtime_best = duration_in_seconds_of(segment['BestSegmentTime'][0]['RealTime'].try(:[], 0))
        split.realtime_skipped = split.realtime_duration == 0

        if split.realtime_duration > 0
          split.realtime_gold = split.realtime_duration.round(5) <= split.realtime_best.try(:round, 5)
        else
          spit.realtime_gold = false
        end

        split.realtime_history = []
        split.indexed_history = {}

        if !fast
          split.realtime_history = segment['SegmentHistory'][0]['Time']
          split.realtime_history.map! do |time|
            t = time['RealTime'].nil? ? 0 : duration_in_seconds_of(time['RealTime'][0].try(:strip))
            split.indexed_history[time['id']] = t
            t
          end
        end

        run[:realtime_time] += split.realtime_duration if split.realtime_duration.present?
        split
      end

      # it's possible to get here with valid xml without this actually being a livesplit file, so let's make sure
      if [run[:attempts], run[:offset], run[:splits], run[:realtime_time]].any?(&:nil?)
        raise "Not a proper LiveSplit run file"
      end

      run
    end

    # LiveSplit parsing pre-1.6 waterfalls down to the lowest version possible. For instance, 1.3 and 1.2 parse almost
    # identically except for a minor difference in positioning of split times. So the 1.3 function parses only splits,
    # then hands the rest of the XML off to the 1.2 function, which parses the rest as if it were 1.2 content.

    # lss file format 1.4 is used by LiveSplit 1.4.x and LiveSplit 1.5.x
    def v1_4(xml, fast)
      run = {
        splits: [],
        realtime_time: 0,
        realtime_history: fast ? nil : (xml['RunHistory'][0]['Time'] || []).map do |t|
          duration_in_seconds_of(t['RealTime'].try(:[], 0))
        end.reject { |t| t == 0 }.uniq
      }

      xml['Segments'][0]['Segment'].each do |segment|
        split = Split.new
        split.name = segment['Name'][0].present? ? segment['Name'][0] : ''

        split.realtime_end = duration_in_seconds_of(segment['SplitTimes'][0]['SplitTime'].select do |k, _|
          k['name'] == 'Personal Best'
        end[0]['RealTime'].try(:[], 0) || '00:00:00.00')
        split.realtime_duration = split.realtime_end - run[:realtime_time]
        split.realtime_duration = 0 if split.realtime_duration < 0
        split.realtime_start = split.realtime_end - split.realtime_duration

        best_segment = segment['BestSegmentTime'][0]['RealTime'].try(:[], 0)
        split.realtime_best = duration_in_seconds_of(best_segment)
        split.realtime_skipped = split.realtime_duration == 0

        if split.realtime_duration > 0
          split.realtime_gold = split.realtime_duration.round(5) <= split.realtime_best.try(:round, 5)
        else
          split.realtime_gold = false
        end

        split.realtime_history = []
        split.indexed_history = {}

        if !fast
          split.realtime_history = segment['SegmentHistory'][0]['Time']
          if split.realtime_history.present?
            split.realtime_history.map! do |time|
              t = time['RealTime'].nil? ? 0 : duration_in_seconds_of(time['RealTime'].try(:[], 0).try(:strip))
              split.indexed_history[time['id']] = t
            end
          end
        end

        run[:realtime_time] += split.realtime_duration if split.realtime_duration.present?
        run[:splits] << split
      end
      v1_3(xml, fast, run)
    end

    # lss file format 1.3 is used by LiveSplit 1.3.x
    def v1_3(xml, fast, run = {})
      run = {
        splits: [],
        realtime_time: 0
      }.merge(run)
      run[:name] = "#{run[:game]} #{run[:category]}".strip

      if run[:splits].empty?
        xml['Segments'][0]['Segment'].each do |segment|
          split = Split.new
          split.name = segment['Name'][0].present? ? segment['Name'][0] : ''

          # Okay what the hell. There's no way XML parsing is this crazy.
          # Somebody please enlighten me. Maybe I should switch this to Nokogiri.
          split.realtime_end = duration_in_seconds_of(segment['SplitTimes'].first.first.second.select do |k, _|
            k['name'] == 'Personal Best'
          end.first['content'].strip)
          split.realtime_duration = split.realtime_end - run[:realtime_time]
          split.realtime_duration = 0 if split.realtime_duration < 0

          best_segment = segment['BestSegmentTime'][0]
          best_segment = best_segment[0] if best_segment.is_a?(Hash)
          split.realtime_best = duration_in_seconds_of(best_segment)
          split.realtime_skipped = split.realtime_duration == 0
          split.realtime_start = split.realtime_end - split.realtime_duration

          if split.realtime_duration > 0
            split.realtime_gold = split.realtime_duration.round(5) == split.realtime_best.try(:round, 5)
          else
            split.realtime_gold = false
          end

          split.realtime_history = fast ? nil : segment['SegmentHistory'][0]['Time'].try do |times|
            times.map { |time| duration_in_seconds_of(time['content'].strip) }
          end

          run[:realtime_time] += split.realtime_duration if split.realtime_duration.present?
          run[:splits] << split
        end
      end
      v1_2(xml, fast, run)
    end

    # lss file format 1.2 is used by LiveSplit 1.2.x and below
    def v1_2(xml, fast, run = {})
      run = {
        game:     xml['GameName'][0].try(:strip),
        category: xml['CategoryName'][0].try(:strip),
        attempts: xml['AttemptCount'][0].to_i,
        offset:   duration_in_seconds_of(xml['Offset'][0].try(:strip)),
        realtime_history:  if !fast && xml['RunHistory'][0]['Time'].present?
                             xml['RunHistory'][0]['Time'].map do |t|
                               duration_in_seconds_of(t['content'])
                             end.reject { |t| t == 0 }
                           else
                             []
                           end,
        splits:   [],
        realtime_time:     0
      }.merge(run)
      run[:name] = "#{run[:game]} #{run[:category]}".strip

      if run[:splits].empty?
        xml['Segments'][0]['Segment'].each do |segment|
          split = Split.new
          split.name = segment['Name'][0].present? ? segment['Name'][0] : ''
          split.realtime_end = duration_in_seconds_of(segment['PersonalBestSplitTime'][0])

          split.realtime_duration = split.realtime_end - run[:realtime_time]
          split.realtime_duration = 0 if split.realtime_duration < 0
          split.realtime_best = duration_in_seconds_of(segment['BestSegmentTime'][0])
          split.realtime_skipped = split.realtime_duration == 0
          split.realtime_start = split.realtime_end - split.realtime_duration

          if split.realtime_duration > 0
            split.realtime_gold = split.realtime_duration.round(5) == split.realtime_best.try(:round, 5)
          else
            split.realtime_gold = false
          end

          split.realtime_history = fast ? nil : segment['SegmentHistory'][0]['Time'].try do |times|
            times.map { |time| duration_in_seconds_of(time['content'].strip) }
          end

          run[:realtime_time] += split.realtime_duration if split.realtime_duration.present?
          run[:splits] << split
        end
      end

      # it's possible to get here with valid xml without this actually being a livesplit file, so let's make sure
      if [run[:attempts], run[:offset], run[:splits], run[:realtime_time]].any?(&:nil?)
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
