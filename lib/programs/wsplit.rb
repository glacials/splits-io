module WSplit
  def self.to_s
    'WSplit'
  end

  def self.to_sym
    :wsplit
  end

  def self.file_extension
    'wsplit'
  end

  def self.website
    'https://github.com/Nitrofski/WSplit'
  end

  def self.content_type
    'application/wsplit'
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
