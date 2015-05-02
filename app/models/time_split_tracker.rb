module TimeSplitTracker
  def self.to_s
    "Time Split Tracker"
  end

  class Run < Run
    def self.sti_name
      :timesplittracker
    end
  end
  class Split < Split
  end
end
