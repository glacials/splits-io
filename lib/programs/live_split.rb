module Programs::LiveSplit
  def self.to_s
    'LiveSplit'
  end

  def self.to_sym
    :livesplit
  end

  def self.file_extension
    'lss'
  end

  def self.website
    'https://livesplit.org/'
  end

  def self.content_type
    'application/livesplit'
  end

  def self.exportable?
    true
  end

  # exchangeable? is true if the timer supports the Splits.io Exchange Format for importing and exporting, false
  # otherwise. See: https://github.com/glacials/splits-io/tree/master/public/schema
  def self.exchangeable?
    true
  end
end
