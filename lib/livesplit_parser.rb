require 'active_support'
require 'ostruct'
require 'xmlsimple'

class LiveSplitParser

  def parse(xml)
    begin
      xml = XmlSimple.xml_in(xml)
      version = Versionomy.parse(xml['version'] || '1.2')
      run = OpenStruct.new
      return v1_3(run, xml) if version >= Versionomy.parse('1.3')
      return v1_2(run, xml) if version >= Versionomy.parse('1.2')
      return nil
    rescue REXML::ParseException
      nil
    end
  end

  private

  # LiveSplit version parsing waterfalls down to the lowest version possible. For instance, 1.3 and 1.2 parse almost
  # identically except for a minor difference in positioning of split times. So the 1.3 function parses only splits,
  # then hands the rest of the XML off to the 1.2 function, which parses the rest as if it were 1.2 content.

  def v1_3(run, xml)
    run.splits ||= Array.new
    run.time   ||= 0
    xml['Segments'].first.first.second.each do |segment|
      split = OpenStruct.new
      split.best = OpenStruct.new
      split.name = segment['Name'].first

      # Okay what the hell. There's no way XML parsing is this crazy.
      # Somebody please enlighten me. Maybe I should switch this to Nokogiri.
      split.finish_time = duration_in_seconds_of(segment['SplitTimes'].first.first.second
                                                .select{ |k, v| k['name'] == "Personal Best" }.first['content'].strip)
      split.duration = split.finish_time - run.time
      split.duration = 0 if split.duration < 0
      split.best.duration = duration_in_seconds_of(segment['BestSegmentTime'].first.strip)
      split.parent = run
      run.time += split.duration if split.duration.present?
      run.splits << split
    end
    return v1_2(run, xml)
  end

  def v1_2(run, xml)
    run.game     ||= xml['GameName'].first.present?     ? xml['GameName'].first     : ''
    run.category ||= xml['CategoryName'].first.present? ? xml['CategoryName'].first : ''
    run.name     ||= run.game + " " + run.category
    run.attempts ||= xml['AttemptCount'].first.present? ? xml['AttemptCount'].first : ''
    run.offset   ||= duration_in_seconds_of(xml['Offset'].first)
    run.history  ||= xml['RunHistory'].first['Time'].present? ? xml['RunHistory'].first['Time'].map{ |t| duration_in_seconds_of(t['content']) }.reject{ |t| t == 0 } : []
    run.splits   ||= Array.new
    run.time     ||= 0
    if run.splits.empty?
      xml['Segments'].first.first.second.each do |segment|
        split = OpenStruct.new
        split.best = OpenStruct.new
        split.name = segment['Name'].first
        split.finish_time = duration_in_seconds_of(segment['PersonalBestSplitTime'].first)
        split.duration = split.finish_time - run.time
        split.duration = 0 if split.duration < 0
        split.best.duration = duration_in_seconds_of(segment['BestSegmentTime'].first)
        split.parent = run
        run.time += split.duration if split.duration.present?
        run.splits << split
      end
    end
    return run
  end

  def duration_in_seconds_of(time)
    return 0 if time.blank?
    Time.parse(time).seconds_since_midnight
  end
end
