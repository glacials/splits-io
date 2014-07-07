module Split
  def name
    map(&:name).join(' + ')
  end
  def duration
    map(&:duration).sum
  end
end
