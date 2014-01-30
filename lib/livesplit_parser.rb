require 'active_support'
require 'ostruct'

class LivesplitParser

  def parse(splits)
    begin
      splits = Hash.from_xml(splits)
      run = OpenStruct.new
      run.game = splits['Run']['GameName']
      run.title = splits['Run']['CategoryName']
      run.attempts = splits['Run']['AttemptCount']
      run.offset = splits['Run']['Offset']
      run.splits = Array.new
      run_time = 0
      splits['Run']['Segments'].first.second.each do |segment|
        split = OpenStruct.new
        split.title = segment['Name']
        split.best_time = duration_in_seconds_of segment['PersonalBestSplitTime']
        split.run_time  = duration_in_seconds_of segment['BestSegmentTime']
        split.parent = run
        run_time += split.best_time
        run.splits << split
      end
      run
    rescue REXML::ParseException
      nil
    end
  end

  def duration_in_seconds_of(time)
    Time.parse(time).seconds_since_midnight
  end

  def game
    Hash.from_xml(xml.to_s)['Run']['GameName']
  end
  def title
    Hash.from_xml(xml.to_s)['Run']['CategoryName']
  end
  #def offset
    #Hash.from_xml(xml.to_s)['Run']['Offset']
  #end
  def attempts
    Hash.from_xml(xml.to_s)['Run']['AttemptCount']
  end
  def splits
    splits = Hash.from_xml(xml.to_s)['Run']['Segments'].first.second
    splits.map!{ |s| OpenStruct.new(Hash[s.map{ |k, v| [k.downcase, v] }]) }
    splits.each do |s|
      s.run_time  = s.personalbestsplittime
      s.best_time = s.bestsegmenttime
      s.delete_field('icon')
      s.delete_field('personalbestsplittime')
      s.delete_field('bestsegmenttime')
    end
    splits
  end

end
