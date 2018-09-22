module SplitsIO
  def self.to_s
    'Splits I/O Exchange Format'
  end

  def self.to_sym
    :splitsio
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

  def self.exportable
    true
  end
end
