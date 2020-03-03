module Programs::Urn
  def self.to_s
    'Urn'
  end

  def self.to_sym
    :urn
  end

  def self.file_extension
    'json'
  end

  def self.website
    'https://github.com/3snowp7im/urn'
  end

  def self.content_type
    'application/urn'
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
