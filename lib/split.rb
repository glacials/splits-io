module Split
  def name
    map(&:name).join(' + ')
  end
  def duration
    map(&:duration).sum
  end
  def amalgam?
    count > 1
  end
end
