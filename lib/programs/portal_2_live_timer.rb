module Programs::Portal2LiveTimer
  def self.to_s
    'Portal 2 Live Timer'
  end

  def self.to_sym
    :portal_2_live_timer
  end

  def self.file_extension
    'csv'
  end

  def self.website
    'https://bitbucket.org/nick_timkovich/portal-2-live-timer/wiki/Home'
  end

  def self.content_type
    'application/portal-2-live-timer'
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
