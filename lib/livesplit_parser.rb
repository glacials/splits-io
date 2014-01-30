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
      run_duration_so_far = 0
      splits['Run']['Segments'].first.second.each do |segment|
        split = OpenStruct.new
        split.title = segment['Name']
        split.best_time = duration_in_seconds_of(segment['PersonalBestSplitTime']) - run_duration_so_far
        split.run_time  = duration_in_seconds_of(segment['BestSegmentTime'])
        split.parent = run
        run_duration_so_far += split.best_time
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
end
