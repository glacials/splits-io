module ExchangeFormat
  def self.to_s
    'Splits.io Exchange Format'
  end

  def self.to_sym
    :exchange
  end

  def self.file_extension
    'json'
  end

  def self.website
    'https://github.com/glacials/splits-io/tree/master/public/schema'
  end

  def self.content_type
    'application/splitsio'
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
