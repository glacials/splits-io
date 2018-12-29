class Duration
  def initialize(milliseconds)
    @ms = milliseconds
  end

  # format accepts a number of milliseconds and returns a time like "HH:MM:SS". If precise is true, it returns a time
  # like "HH:MM:SS.mmm" instead.
  def format(precise: false)
    return '-' if @ms.nil?

    return Kernel.format('%02d:%02d:%02d.%03d', hours, minutes, seconds, milliseconds) if precise
    Kernel.format('%02d:%02d:%02d', hours, minutes, seconds)
  end

  # format_casual returns a string like "3m 2s". num_units specifies the max number of unit types to display, e.g. a
  # num_units of 3 will show something like "3m 2s 123ms". The units used are biggest-first, starting with the biggest
  # non-zero unit. Numbers are truncated, not rounded.
  def format_casual(num_units: 2)
    return '-' if @ms.nil? || @ms.zero?

    {
      h:  hours,
      m:  minutes,
      s:  seconds,
      ms: milliseconds
    }.drop_while { |_, unit| unit.zero? }.first(num_units).to_h.map { |k, v| "#{v.to_i}#{k}" }.join(' ')
  end

  def as_ms
    @ms
  end

  private

  def hours
    @ms / 1000 / 60 / 60
  end

  def minutes
    @ms / 1000 / 60 % 60
  end

  def seconds
    @ms / 1000 % 60
  end

  def milliseconds
    @ms % 1000
  end
end
