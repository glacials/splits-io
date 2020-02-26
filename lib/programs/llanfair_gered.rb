module Programs::LlanfairGered
  def self.to_s
    "Llanfair (Gered's fork)"
  end

  def self.to_sym
    :llanfair_gered
  end

  def self.file_extension
    'lfs'
  end

  def self.website
    'https://github.com/gered/Llanfair'
  end

  def self.content_type
    'application/llanfair-gered'
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
