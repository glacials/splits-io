module SplitterZ
  def self.to_s
    'SplitterZ'
  end

  def self.to_sym
    :splitterz
  end

  def self.file_extension
    'splitterz'
  end

  def self.website
    'http://splitterz420.blogspot.com/'
  end

  def self.content_type
    'application/splitterz'
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
