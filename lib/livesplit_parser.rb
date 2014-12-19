require 'active_support'
require 'ostruct'
require 'xmlsimple'

class LiveSplitParser < BabelBridge::Parser
  def parse(xml)
    xml = XmlSimple.xml_in(xml)
    version = Versionomy.parse(xml['version'] || '1.2')
    return v1_4(xml) if version >= Versionomy.parse('1.4')
    return v1_3(xml) if version >= Versionomy.parse('1.3')
    return v1_2(xml) if version >= Versionomy.parse('1.2')
    return nil
  rescue
    nil
  end

  private

  # LiveSplit version parsing waterfalls down to the lowest version possible. For instance, 1.3 and 1.2 parse almost
  # identically except for a minor difference in positioning of split times. So the 1.3 function parses only splits,
  # then hands the rest of the XML off to the 1.2 function, which parses the rest as if it were 1.2 content.

  def v1_4(xml, run = {})
    run[:splits] ||= []
    run[:time]   ||= 0
    if run[:splits].empty?
      xml['Segments'][0]['Segment'].each do |segment|
        split = {}
        split[:best] = {}
        split[:name] = segment['Name'][0].present? ? segment['Name'][0] : ''

        split[:finish_time] = duration_in_seconds_of(segment['SplitTimes'][0]['SplitTime'].select do |k, _|
          k['name'] == 'Personal Best'
        end[0]['RealTime'].try(:[], 0) || '00:00:00.00')
        split[:duration] = split[:finish_time] - run[:time]
        split[:duration] = 0 if split[:duration] < 0

        best_segment = segment['BestSegmentTime'][0]['RealTime'].try(:[], 0)
        best_segment = best_segment[0] if best_segment.is_a?(Hash)
        split[:best][:duration] = duration_in_seconds_of(best_segment)

        run[:time] += split[:duration] if split[:duration].present?
        run[:splits] << split
      end
    end
    v1_3(xml, run)
  end

  def v1_3(xml, run = {})
    run[:splits] ||= []
    run[:time]   ||= 0
    if run[:splits].empty?
      xml['Segments'][0]['Segment'].each do |segment|
        split = {}
        split[:best] = {}
        split[:name] = segment['Name'][0].present? ? segment['Name'][0] : ''

        # Okay what the hell. There's no way XML parsing is this crazy.
        # Somebody please enlighten me. Maybe I should switch this to Nokogiri.
        split[:finish_time] = duration_in_seconds_of(segment['SplitTimes'].first.first.second.select do |k, _|
          k['name'] == 'Personal Best'
        end.first['content'].strip)
        split[:duration] = split[:finish_time] - run[:time]
        split[:duration] = 0 if split[:duration] < 0

        best_segment = segment['BestSegmentTime'][0]
        best_segment = best_segment[0] if best_segment.is_a?(Hash)
        split[:best][:duration] = duration_in_seconds_of(best_segment)

        run[:time] += split[:duration] if split[:duration].present?
        run[:splits] << split
      end
    end
    v1_2(xml, run)
  end

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
        split = {}
        split[:best] = {}
        split[:name] = segment['Name'][0].present? ? segment['Name'][0] : ''
        split[:finish_time] = duration_in_seconds_of(segment['PersonalBestSplitTime'][0])

        split[:duration] = split[:finish_time] - run[:time]
        split[:duration] = 0 if split[:duration] < 0
        split[:best][:duration] = duration_in_seconds_of(segment['BestSegmentTime'][0])

        run[:time] += split[:duration] if split[:duration].present?
        run[:splits] << split
      end
    end
    run
  end

  def duration_in_seconds_of(time)
    return 0 if time.blank?
    Time.parse(time).seconds_since_midnight
  end
end
