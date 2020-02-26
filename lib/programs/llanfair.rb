module Programs::Llanfair
  def self.to_s
    'Llanfair'
  end

  def self.to_sym
    :llanfair
  end

  def self.file_extension
    'llanfair'
  end

  def self.website
    'http://jenmaarai.com/llanfair/en/'
  end

  def self.content_type
    'application/llanfair'
  end

  def self.exportable?
    false
  end

  # exchangeable? is true if the timer supports the Splits.io Exchange Format for importing and exporting, false
  # otherwise. See: https://github.com/glacials/splits-io/tree/master/public/schema
  def self.exchangeable?
    false
  end
end
