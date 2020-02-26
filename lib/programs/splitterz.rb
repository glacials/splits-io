# Since this program doesn't form 2 logical words, an inflector is used to preserve the capital Z at the end
# Check out config/initializers/inflections.rb to view it

module Programs::SplitterZ
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

  # exchangeable? is true if the timer supports the Splits.io Exchange Format for importing and exporting, false
  # otherwise. See: https://github.com/glacials/splits-io/tree/master/public/schema
  def self.exchangeable?
    false
  end
end
