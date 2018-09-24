module SourceLiveTimer
  def self.to_s
    'SourceLiveTimer'
  end

  def self.to_sym
    :sourcelivetimer
  end

  def self.file_extension
    'sourcelivetimer'
  end

  def self.website
    'https://github.com/iVerb1/SourceLiveTimer'
  end

  def self.content_type
    'application/source-live-timer'
  end

  def self.exportable?
    false
  end

  # exchangeable? is true if the timer supports the Splits I/O Exchange Format for importing and exporting, false
  # otherwise. See: https://github.com/glacials/splits-io/tree/master/public/schema
  def self.exchangeable?
    false
  end
end
