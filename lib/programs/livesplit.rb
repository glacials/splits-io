module LiveSplit
  def self.to_s
    "LiveSplit"
  end

  def self.to_sym
    :livesplit
  end

  def self.file_extension
    'lss'
  end

  def self.website
    'http://livesplit.org/'
  end

  def self.content_type
    'application/livesplit'
  end

  def self.exportable
    true
  end
end
