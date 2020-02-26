module Programs::Splitty
  def self.to_s
    'Splitty'
  end

  def self.to_sym
    :splitty
  end

  def self.file_extension
    'json'
  end

  def self.website
    'http://ylorant.github.io/splitty'
  end

  def self.content_type
    'application/splitty'
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
