module Programs::FramePerfect
  def self.to_s
    'FramePerfect'
  end

  def self.to_sym
    :frameperfect
  end

  def self.file_extension
    'json'
  end

  def self.website
    'https://futuretrostudios.com/frameperfect/'
  end

  def self.content_type
    'application/splitsio'
  end

  def self.exportable?
    false
  end

  # exchangeable? is true if the timer supports the Splits I/O Exchange Format for importing and exporting, false
  # otherwise. See: https://github.com/glacials/splits-io/tree/master/public/schema
  def self.exchangeable?
    true
  end
end
