module Llanfair2
  def self.to_s
    'Llanfair Rewrite'
  end

  def self.to_sym
    :llanfair2
  end

  def self.file_extension
    'llanfair2'
  end

  def self.website
    'http://jenmaarai.com/llanfair/en/'
  end

  def self.content_type
    'application/llanfair2'
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
