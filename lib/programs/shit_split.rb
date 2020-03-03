module Programs::ShitSplit
  def self.to_s
    'ShitSplit'
  end

  def self.to_sym
    :shitsplit
  end

  def self.file_extension
    'ss'
  end

  def self.website
    'https://www.dropbox.com/s/tje563s0c0fy6lk/ShitSplit04a.zip?dl=0'
  end

  def self.content_type
    'application/shitsplit'
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
