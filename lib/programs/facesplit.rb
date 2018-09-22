module FaceSplit
  def self.to_s
    'FaceSplit'
  end

  def self.to_sym
    :facesplit
  end

  def self.file_extension
    'fss'
  end

  def self.website
    'https://github.com/pnolin/FaceSplit'
  end

  def self.content_type
    'application/facesplit'
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
