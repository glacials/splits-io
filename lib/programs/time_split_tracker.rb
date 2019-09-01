module Programs::TimeSplitTracker
  def self.to_s
    'Time Split Tracker'
  end

  def self.to_sym
    :timesplittracker
  end

  def self.file_extension
    'timesplittracker'
  end

  def self.website
    'https://dunnius.itch.io/time-split-tracker-windows'
  end

  def self.content_type
    'application/time-split-tracker'
  end

  def self.exportable?
    true
  end

  # exchangeable? is true if the timer supports the Splits I/O Exchange Format for importing and exporting, false
  # otherwise. See: https://github.com/glacials/splits-io/tree/master/public/schema
  def self.exchangeable?
    false
  end
end
