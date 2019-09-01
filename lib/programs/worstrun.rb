module Programs::Worstrun
  def self.to_s
    'worstrun'
  end

  def self.to_sym
    :worstrun
  end

  def self.file_extension
    'json'
  end

  def self.website
    'https://github.com/Muffindrake/worstrun'
  end

  def self.content_type
    'application/worstrun'
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
