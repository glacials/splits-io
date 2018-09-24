module FaceSplit
  def self.to_s
    'Floating Speedrun Timer'
  end

  def self.to_sym
    :floating_speedrun_timer
  end

  def self.file_extension
    'json'
  end

  def self.website
    'https://play.google.com/store/apps/details?id=il.ronmad.speedruntimer'
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
